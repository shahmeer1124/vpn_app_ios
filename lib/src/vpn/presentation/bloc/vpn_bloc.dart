import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_available_servers_list.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/usecases/get_user_location_usecase.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnStateHolder> {
  VpnBloc(
      {required GetAvailableServerListUseCase getAvailableServerList,
      required GetUserLocationUseCase getUserLocationUseCase})
      : _getAvailableServerListUseCase = getAvailableServerList,
        _getUserLocationUseCase = getUserLocationUseCase,
        super(const VpnStateHolder()) {
    on<GetUserLocationEvent>(_getUserLocation);
    on<GetAvailableServerListEvent>(_getServersList);
    on<TestEvent>(_runTestEvent);
    on<ChangeSelectedVpn>(_updateSelectedServer);
  }

  Future<void> _runTestEvent(
    TestEvent event,
    Emitter<VpnStateHolder> emit,
  ) async {
    print('test event is running');
  }

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
    emit(state.copyWith(fetchingIpApi: FetchingIpAp.fetching));
    final result = await _getUserLocationUseCase();
    result.fold((error) {
      emit(state.copyWith(fetchingIpApi: FetchingIpAp.error));
    }, (data) {
      emit(state.copyWith(
        fetchingIpApi: FetchingIpAp.fetched,
        userCurrentLat: data.lat,
        userCurrentLong: data.lon,
      ));
    });
  }

  final GetAvailableServerListUseCase _getAvailableServerListUseCase;
  final GetUserLocationUseCase _getUserLocationUseCase;
}
