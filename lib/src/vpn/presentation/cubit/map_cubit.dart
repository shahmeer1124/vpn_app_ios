import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.vpnBloc})
      : super(MapState.initial(
          latitude: vpnBloc.state.userCurrentLat,
          longitude: vpnBloc.state.userCurrentLong,
        )) {
    vpnBloc.stream.listen((vpnState) {
      updateMapState(vpnState.userCurrentLat, vpnState.userCurrentLong);
    });
  }
  final VpnBloc vpnBloc;

  void updateMapState(double latitude, double longitude) {
    emit(MapState.initial(latitude: latitude, longitude: longitude));
  }
}
