import 'dart:async';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:openvpn_flutter_example/src/network_info/presentation/cubit/network_info_cubit.dart';
import 'package:openvpn_flutter_example/src/vpn/data/data_source/vpn_datasource.dart';
import 'package:openvpn_flutter_example/src/vpn/data/repos/vpn_repo_impl.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/repos/vpn_repo.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_available_servers_list.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_user_location_usecase.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';

final sl = GetIt.instance;

class VpnEventBus {
  final _statusController = StreamController<VpnStatus>.broadcast();
  final _stageController = StreamController<String>.broadcast();

  Stream<VpnStatus> get onStatusChanged => _statusController.stream;
  Stream<String> get onStageChanged => _stageController.stream;

  void updateStatus(VpnStatus status) => _statusController.add(status);
  void updateStage(String stage) => _stageController.add(stage);

  void dispose() {
    _statusController.close();
    _stageController.close();
  }
}

Future<void> init() async {
  await _initVpnBloc();
  await _initNetworkInfo();
}

Future<void> _initVpnBloc() async {
  // Register event bus
  sl
    ..registerSingleton<VpnEventBus>(VpnEventBus())
    ..registerFactory(
      () => VpnBloc(
        getAvailableServerList: sl(),
        getUserLocationUseCase: sl(),
        openVpn: sl(),
        eventBus: sl(),
        advancedDrawerController: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAvailableServerListUseCase(sl()))
    ..registerLazySingleton(() => GetUserLocationUseCase(sl()))
    ..registerLazySingleton<VpnRepo>(() => VpnRepoImpl(sl()))
    ..registerLazySingleton<VpnDataSource>(
      VpnDataSrcImpl.new,
    )
    ..registerLazySingleton<OpenVPN>(
      () => OpenVPN(
        onVpnStatusChanged: (status) {
          if (status != null) {
            try {
              sl<VpnEventBus>().updateStatus(status);
            } catch (e) {}
          }
        },
        onVpnStageChanged: (stage, raw) {
          sl<VpnEventBus>().updateStage(raw);
        },
      ),
    )
    ..registerLazySingleton(AdvancedDrawerController.new);
}

Future<void> _initNetworkInfo() async {
  sl
    ..registerLazySingleton<NetworkInfo>(NetworkInfo.new)
    ..registerFactory(() => NetworkInfoCubit(sl()));
}


