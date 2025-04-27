part of 'vpn_bloc.dart';

class VpnEvent extends Equatable {
  const VpnEvent();
  @override
  List<Object?> get props => [];
}

class GetUserLocationEvent extends VpnEvent {
  const GetUserLocationEvent();
  @override
  List<Object?> get props => [];
}

class GetAvailableServerListEvent extends VpnEvent {
  const GetAvailableServerListEvent();
  @override
  List<Object?> get props => [];
}

class TestEvent extends VpnEvent {
  const TestEvent();
  @override
  List<Object?> get props => [];
}

class ChangeSelectedVpn extends VpnEvent {
  const ChangeSelectedVpn({required this.vpnNewModel});
  final Vpn vpnNewModel;

  @override
  List<Object?> get props => [vpnNewModel];
}
