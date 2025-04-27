import 'package:get_it/get_it.dart';
import 'package:openvpn_flutter_example/src/vpn/data/data_source/vpn_datasource.dart';
import 'package:openvpn_flutter_example/src/vpn/data/repos/vpn_repo_impl.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/repos/vpn_repo.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_available_servers_list.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_user_location_usecase.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  await _initVpnBloc();
}

Future<void> _initVpnBloc() async {
  sl
    ..registerFactory(
      () => VpnBloc(
        getAvailableServerList: sl(),
        getUserLocationUseCase: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAvailableServerListUseCase(sl()))
    ..registerLazySingleton(() => GetUserLocationUseCase(sl()))
    ..registerLazySingleton<VpnRepo>(() => VpnRepoImpl(sl()))
    ..registerLazySingleton<VpnDataSource>(
      VpnDataSrcImpl.new,
    );
}
