import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:openvpn_flutter_example/core/services/injection_container_main.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_available_servers_list.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_user_location_usecase.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/filter_function.dart';
part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnStateHolder> {
  VpnBloc({
    required GetAvailableServerListUseCase getAvailableServerList,
    required GetUserLocationUseCase getUserLocationUseCase,
    required OpenVPN openVpn,
    required VpnEventBus eventBus,
    required AdvancedDrawerController advancedDrawerController,
  })  : _getAvailableServerListUseCase = getAvailableServerList,
        _getUserLocationUseCase = getUserLocationUseCase,
        _openVpn = openVpn,
        drawerController = advancedDrawerController,
        super(const VpnStateHolder()) {
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
    on<SelectSmartServer>(_onSmartLocationSelection, transformer: droppable());
    on<ChangeHotelFilter>(_changeFilterType);
    eventBus.onStatusChanged.listen((status) {
      add(VpnStatusUpdated(status));
    });
    eventBus.onStageChanged.listen((stage) {
      add(VpnStageUpdated(stage));
    });
    add(const InitializeVpn());
  }
  Future<void> _onVpnStatusUpdated(
    VpnStatusUpdated event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(
      state.copyWith(
        vpnStatus: event.status,
      ),
    );
  }

  Future<void> _changeFilterType(
    ChangeHotelFilter event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(sortingStart: Sorting.sorting));
    List<Vpn> filteredVpn = event.filterType.applyAll(
      state.vpnList,
      event.filterType,
      event.hoteName,
    );
    emit(state.copyWith(
        filteringType: event.filterType,
        vpnList: filteredVpn,
        sortingStart: Sorting.sorted));
  }

  String? _lastFetchedStage;

  Future<void> _onSmartLocationSelection(
    SelectSmartServer event,
    Emitter<VpnStateHolder> emit,
  ) async {
    try {
      if (state.vpnStage.toLowerCase() == 'connected' ||
          state.vpnStage.toLowerCase() == 'connecting') {
        if (state.smartestServerSelection ==
            SmartestServerSelection.connected) {
          add(const DisconnectVpn());
          emit(
            state.copyWith(
              smartServerSelection: SmartestServerSelection.initial,
            ),
          );
        } else {
          add(const DisconnectVpn());

          await Future.delayed(const Duration(milliseconds: 500), () {});
          emit(
            state.copyWith(
              selectedVpn: state.sortedVpn.first,
              smartServerSelection: SmartestServerSelection.connected,
            ),
          );
          add(ConnectVpn(context: event.context));
        }
      } else if (state.smartestServerSelection ==
          SmartestServerSelection.connected) {
        return;
      } else {
        emit(
          state.copyWith(
            selectedVpn: state.sortedVpn.first,
            smartServerSelection: SmartestServerSelection.connected,
          ),
        );
        add(ConnectVpn(context: event.context));
      }
    } catch (e) {}
  }

  Future<void> _onVpnStageUpdated(
    VpnStageUpdated event,
    Emitter<VpnStateHolder> emit,
  ) async {
    if (event.stage.toLowerCase() == 'disconnected') {
      emit(
        state.copyWith(
            vpnStage: event.stage,
            smartServerSelection: state.smartestServerSelection ==
                    SmartestServerSelection.connected
                ? SmartestServerSelection.initial
                : SmartestServerSelection.initial,
            showServerIsSlow: ShowServerIsSlowMessage.hide),
      );
      if (_lastFetchedStage != 'disconnected') {
        _lastFetchedStage = 'disconnected';
        add(const GetUserLocationEvent());
      }
    } else if (event.stage.toLowerCase() == 'connected') {
      emit(
        state.copyWith(
          vpnStage: event.stage,
          showServerIsSlow: ShowServerIsSlowMessage.hide,
        ),
      );
      if (_lastFetchedStage != 'connected') {
        _lastFetchedStage = 'connected';
        add(const GetUserLocationEvent());
      }
    } else {
      emit(
        state.copyWith(
          vpnStage: event.stage,
        ),
      );
      _lastFetchedStage = null; // Reset for other stages
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
          add(
            VpnStageUpdated(
              stage.name,
            ),
          );
        },
        lastStatus: (status) {
          add(VpnStatusUpdated(status));
        },
      );
      emit(
        state.copyWith(
          vpnStage: 'disconnected',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          vpnStage: 'error',
        ),
      );
    }
  }

  Future<void> _connectVpn(
    ConnectVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(state.copyWith(
        vpnStage: 'connecting',
        showServerIsSlow: ShowServerIsSlowMessage.initial));
    try {
      final data = const Base64Decoder()
          .convert(state.selectedVpn.openVPNConfigDataBase64);
      final config = const Utf8Decoder().convert(data);

      final warningFuture = Future.delayed(
        const Duration(seconds: 20),
        () async {
          if (state.vpnStage.toLowerCase() == 'connecting') {
            emit(
              state.copyWith(showServerIsSlow: ShowServerIsSlowMessage.show),
            );
          }
        },
      );

      await Future.wait([
        _openVpn
            .connect(
          config,
          state.selectedVpn.countryShort,
          username: 'vpn',
          password: 'vpn',
          certIsRequired: true,
        )
            .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            // _openVpn.disconnect();
            // throw TimeoutException('VPN connection timed out after 60 seconds');
          },
        ),
        warningFuture,
      ]);
    } catch (e) {
      _openVpn.disconnect();
      emit(
        state.copyWith(
          vpnStage: 'disconnected',
          smartServerSelection: SmartestServerSelection.initial,
        ),
      );
    }
  }

  Future<void> _disconnectVpn(
    DisconnectVpn event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(
      state.copyWith(
          vpnStage: 'disconnecting',
          vpnStatus: VpnStatus(duration: '00:00:00'),
          smartServerSelection: SmartestServerSelection.initial,
          showServerIsSlow: ShowServerIsSlowMessage.initial),
    );
    try {
      _openVpn.disconnect();
    } catch (e) {
      emit(
        state.copyWith(
          vpnStage: 'error',
          vpnStatus: VpnStatus(duration: '00:00:00'),
        ),
      );
    }
  }

  Future<void> _requestAndroidPermission(
    RequestAndroidPermission event,
    Emitter<VpnStateHolder> emit,
  ) async {
    if (Platform.isAndroid) {
      try {
        final granted = await _openVpn.requestPermissionAndroid();
        emit(
          state.copyWith(
            isAndroidPermissionGranted: granted,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isAndroidPermissionGranted: false,
          ),
        );
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
    emit(
      state.copyWith(
        selectedVpn: event.vpnNewModel,
      ),
    );
  }

  Future<void> _getServersList(
    GetAvailableServerListEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(
      state.copyWith(
        fetchingAvailableServers: FetchingAvailableServers.fetching,
      ),
    );
    final result = await _getAvailableServerListUseCase();
    result.fold(
      (error) {
        emit(
          state.copyWith(
            fetchingAvailableServers: FetchingAvailableServers.error,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            fetchingAvailableServers: FetchingAvailableServers.fetched,
            vpnList: data,
            selectedVpn: data.isNotEmpty ? data[0] : const Vpn.empty(),
          ),
        );
      },
    );
  }

  Future<void> _getUserLocation(
    GetUserLocationEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {
    emit(
      state.copyWith(
        fetchingIpApi: FetchingIpAp.fetching,
      ),
    );
    final result = await _getUserLocationUseCase();
    await result.fold(
      (error) async {
        print('error occured$error');
        emit(
          state.copyWith(
            fetchingIpApi: FetchingIpAp.error,
          ),
        );
        await Future.delayed(const Duration(seconds: 8), () {});
        emit(
          state.copyWith(
            fetchingIpApi: FetchingIpAp.initial,
          ),
        );
      },
      (data) {
        print('data occured${data.country}');
        emit(
          state.copyWith(
            fetchingIpApi: FetchingIpAp.fetched,
            userCurrentLat: data.lat,
            userCurrentLong: data.lon,
          ),
        );
      },
    );
  }

  final GetAvailableServerListUseCase _getAvailableServerListUseCase;
  final GetUserLocationUseCase _getUserLocationUseCase;
  final OpenVPN _openVpn;
  final AdvancedDrawerController drawerController;
}
