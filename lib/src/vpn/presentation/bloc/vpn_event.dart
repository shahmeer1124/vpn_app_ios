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

class InitializeVpn extends VpnEvent {
  const InitializeVpn({this.openVpn});
  final OpenVPN? openVpn;

  @override
  List<Object?> get props => [openVpn];
}

class ConnectVpn extends VpnEvent {
  const ConnectVpn({required this.context, this.openVpn});
  final BuildContext context;
  final OpenVPN? openVpn;

  @override
  List<Object?> get props => [context, openVpn];
}

class DisconnectVpn extends VpnEvent {
  const DisconnectVpn({this.openVpn});
  final OpenVPN? openVpn;

  @override
  List<Object?> get props => [openVpn];
}

class RequestAndroidPermission extends VpnEvent {
  const RequestAndroidPermission({this.openVpn});
  final OpenVPN? openVpn;

  @override
  List<Object?> get props => [openVpn];
}

class VpnStageUpdated extends VpnEvent {
  const VpnStageUpdated(this.stage);
  final String stage;

  @override
  List<Object?> get props => [stage];
}

class VpnStatusUpdated extends VpnEvent {
  const VpnStatusUpdated(this.status);
  final VpnStatus status;

  @override
  List<Object?> get props => [status];
}
