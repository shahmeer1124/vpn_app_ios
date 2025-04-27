part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    required this.cameraPosition,
    required this.markers,
  });
  factory MapState.initial({
    required double latitude,
    required double longitude,
  }) {
    final initialPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );

    final initialMarker = Marker(
      markerId: const MarkerId('initial_position'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'Your Location',
        snippet: 'This is your current position',
      ),
    );

    return MapState(
      cameraPosition: initialPosition,
      markers: {initialMarker},
    );
  }
  final CameraPosition cameraPosition;
  final Set<Marker> markers;

  @override
  List<Object> get props => [cameraPosition, markers];
}
