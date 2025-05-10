import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.vpnBloc})
      : super(MapState.initial(
          latitude: vpnBloc.state.userCurrentLat ?? 0.0,
          longitude: vpnBloc.state.userCurrentLong ?? 0.0,
        )) {
    vpnBloc.stream.listen((vpnState) {
      if (vpnState.userCurrentLat != state.cameraPosition.target.latitude ||
          vpnState.userCurrentLong != state.cameraPosition.target.longitude) {
        updateMapState(
          vpnState.userCurrentLat,
          vpnState.userCurrentLong,
          animate: vpnState.vpnStage.toLowerCase() == 'connected' ||
              vpnState.vpnStage.toLowerCase() == 'disconnected',
        );
      } else {}
    });
  }

  final VpnBloc vpnBloc;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void setMapController(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      print('MapCubit: Controller set successfully');
    } else {
      controller.dispose();
      print('MapCubit: Extra controller disposed');
    }
  }

  Future<void> updateMapState(double latitude, double longitude,
      {bool animate = false, double? zoomLevel}) async {
    final currentState = state;
    final currentZoom = currentState.cameraPosition.zoom;
    final currentTarget = currentState.cameraPosition.target;

    final targetZoom = zoomLevel ?? 1.4746;

    final targetPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: targetZoom,
    );

    final newMarker = Marker(
      markerId: const MarkerId('current_position'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: vpnBloc.state.vpnStage.toLowerCase() == 'connected'
            ? 'VPN Location'
            : 'Your Location',
        snippet: vpnBloc.state.vpnStage.toLowerCase() == 'connected'
            ? 'Connected to VPN server'
            : 'This is your current position',
      ),
    );

    emit(MapState(
      cameraPosition: targetPosition,
      markers: {newMarker},
    ));

    if (animate && _controller.isCompleted) {
      try {
        final controller =
            await _controller.future.timeout(const Duration(seconds: 5));

        final double distanceInDegrees = _calculateDistance(
            currentTarget.latitude,
            currentTarget.longitude,
            latitude,
            longitude);

        if (distanceInDegrees > 0.1) {
          double intermediateZoom = currentZoom;

          if (distanceInDegrees > 10) {
            intermediateZoom = max(currentZoom - 5, 0);
          } else if (distanceInDegrees > 5) {
            intermediateZoom = max(currentZoom - 3, 0);
          } else if (distanceInDegrees > 1) {
            intermediateZoom = max(currentZoom - 2, 0);
          } else {
            intermediateZoom = max(currentZoom - 1, 0);
          }

          if ((targetZoom - intermediateZoom).abs() < 0.5) {
            intermediateZoom = max(targetZoom - 1.0, 0);
          }

          final intermediatePosition1 = CameraPosition(
            target: currentTarget,
            zoom: intermediateZoom,
          );

          final intermediatePosition2 = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: intermediateZoom,
          );

          final zoomOutDuration = 600;
          final moveDuration = min(1200, (distanceInDegrees * 200).toInt());
          final zoomInDuration = 800;

          await controller.animateCamera(
              CameraUpdate.newCameraPosition(intermediatePosition1),
              duration: Duration(milliseconds: zoomOutDuration));

          await controller.animateCamera(
              CameraUpdate.newCameraPosition(intermediatePosition2),
              duration: Duration(milliseconds: moveDuration));

          await controller.animateCamera(
              CameraUpdate.newCameraPosition(targetPosition),
              duration: Duration(milliseconds: zoomInDuration));

          print('MapCubit: Three-stage animation completed');
        } else {
          final animationDuration = 1000;

          await controller.animateCamera(
              CameraUpdate.newCameraPosition(targetPosition),
              duration: Duration(milliseconds: animationDuration));

          print('MapCubit: Simple animation completed');
        }
      } catch (e) {
        print('MapCubit: Animation error: $e');
      }
    } else {
      print(
          'MapCubit: Animation skipped (animate = $animate, controller completed = ${_controller.isCompleted})');
    }
  }

  @override
  Future<void> close() {
    if (_controller.isCompleted) {
      _controller.future
          .then((controller) => controller.dispose())
          .catchError((e) {
        print('MapCubit: Error disposing controller: $e');
      });
    }
    return super.close();
  }
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  return sqrt(pow(lat2 - lat1, 2) + pow(lon2 - lon1, 2));
}
