import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:openvpn_flutter_example/core/services/injection_container_main.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_available_servers_list.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_user_location_usecase.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnStateHolder> {
  VpnBloc({
    required GetAvailableServerListUseCase getAvailableServerList,
    required GetUserLocationUseCase getUserLocationUseCase,
    required OpenVPN openVpn,
    required VpnEventBus eventBus,
  })  : _getAvailableServerListUseCase = getAvailableServerList,
        _getUserLocationUseCase = getUserLocationUseCase,
        _openVpn = openVpn,
        super(const VpnStateHolder()) {
    print('VpnBloc created with eventBus: $eventBus');
    on<GetUserLocationEvent>(_getUserLocation);
    on<GetAvailableServerListEvent>(_getServersList);
    on<TestEvent>(_runTestEvent);
    on<ChangeSelectedVpn>(_updateSelectedServer);
    on<InitializeVpn>(_initializeVpn);
    on<ConnectVpn>(_connectVpn);
    on<DisconnectVpn>(_disconnectVpn);
    on<RequestAndroidPermission>(_requestAndroidPermission);
    on<VpnStatusUpdated>(_onVpnStatusUpdated);
    on<VpnStageUpdated>(_onVpnStageUpdated);
    print('Setting up VpnBloc listeners');
    eventBus.onStatusChanged.listen((status) {
      print('this is status$status');
      add(VpnStatusUpdated(status));
    });
    eventBus.onStageChanged.listen((stage) {
      print('this is status$stage');
      add(VpnStageUpdated(stage));
    });
    add(const InitializeVpn());
  }

  Future<void> _onVpnStatusUpdated(
    VpnStatusUpdated event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(vpnStatus: event.status));
  }

  Future<void> _onVpnStageUpdated(
    VpnStageUpdated event,
    Emitter<VpnStateHolder> emit,
  ) async {
    if (event.stage.toLowerCase() == 'disconnected') {
      emit(state.copyWith(vpnStage: event.stage, vpnStatus: null));
    } else {
      emit(state.copyWith(vpnStage: event.stage));
    }
  }

  Future<void> _initializeVpn(
    InitializeVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    try {
      await _openVpn.initialize(
        groupIdentifier: 'group.checksum.com.lockScreenWidget',
        providerBundleIdentifier: 'com.vpn.iosapplicationexample.VPNExtension',
        localizedDescription: 'Built with ❤️',
        lastStage: (stage) {
          add(VpnStageUpdated(stage.name));
        },
        lastStatus: (status) {
          add(VpnStatusUpdated(status));
        },
      );

      emit(state.copyWith(vpnStage: 'disconnected', vpnStatus: null));
    } catch (e) {
      emit(state.copyWith(vpnStage: 'error', vpnStatus: null));
    }
  }

  Future<void> _connectVpn(
    ConnectVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(vpnStage: 'connecting', vpnStatus: null));
    try {
      final data = const Base64Decoder()
          .convert(state.selectedVpn.openVPNConfigDataBase64);
      final config = const Utf8Decoder().convert(data);
      print('i am config data$config');

      print('trying to connect');

      await _openVpn
          .connect(
        config,
        state.selectedVpn.countryShort ?? 'USA',
        username: 'vpn',
        password: 'vpn',
        certIsRequired: true,
      )
          .timeout(const Duration(seconds: 60), onTimeout: () {
        _openVpn.disconnect();
        throw TimeoutException('VPN connection timed out after 60 seconds');
      });
      print('connect successfully');
    } catch (e) {
      _openVpn.disconnect();
      emit(state.copyWith(vpnStage: 'disconnected', vpnStatus: null));
    }
  }

  Future<void> _disconnectVpn(
    DisconnectVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    print('this method is called');
    try {
      _openVpn.disconnect();
      emit(state.copyWith(
          vpnStage: 'disconnected',
          vpnStatus: VpnStatus(duration: '00:00:00')));
      print('disconnected success');
    } catch (e) {
      print('this error occurred$e');
      emit(state.copyWith(
          vpnStage: 'error', vpnStatus: VpnStatus(duration: '00:00:00')));
    }
  }

  Future<void> _requestAndroidPermission(
    RequestAndroidPermission event,
    Emitter<VpnStateHolder> emit,
  ) async {
    if (Platform.isAndroid) {
      try {
        final granted = await _openVpn.requestPermissionAndroid();

        emit(state.copyWith(isAndroidPermissionGranted: granted));
      } catch (e) {
        emit(state.copyWith(isAndroidPermissionGranted: false));
      }
    }
  }

  Future<void> _runTestEvent(
    TestEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {}

  Future<void> _updateSelectedServer(
    ChangeSelectedVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(selectedVpn: event.vpnNewModel));
  }

  Future<void> _getServersList(
    GetAvailableServerListEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(
        fetchingAvailableServers: FetchingAvailableServers.fetching));
    final result = await _getAvailableServerListUseCase();
    result.fold(
      (error) {
        emit(state.copyWith(
            fetchingAvailableServers: FetchingAvailableServers.error));
      },
      (data) {
        emit(state.copyWith(
          fetchingAvailableServers: FetchingAvailableServers.fetched,
          vpnList: data,
          selectedVpn: data.isNotEmpty ? data[0] : const Vpn.empty(),
        ));
      },
    );
  }

  Future<void> _getUserLocation(
    GetUserLocationEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(fetchingIpApi: FetchingIpAp.fetching));
    final result = await _getUserLocationUseCase();
    result.fold(
      (error) {
        emit(state.copyWith(fetchingIpApi: FetchingIpAp.error));
      },
      (data) {
        emit(state.copyWith(
          fetchingIpApi: FetchingIpAp.fetched,
          userCurrentLat: data.lat,
          userCurrentLong: data.lon,
        ));
      },
    );
  }

  final GetAvailableServerListUseCase _getAvailableServerListUseCase;
  final GetUserLocationUseCase _getUserLocationUseCase;
  final OpenVPN _openVpn;
}
