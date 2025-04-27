part of 'vpn_bloc.dart';

enum FetchingIpAp { initial, fetching, fetched, error }

enum FetchingAvailableServers { initial, fetching, fetched, error }

enum FetchingInternetStatus { connected, disconnected }

class VpnStateHolder extends Equatable {
  const VpnStateHolder({
    this.fetchingAvailableServers = FetchingAvailableServers.initial,
    this.fetchingIpAp = FetchingIpAp.initial,
    this.fetchingInternetStatus = FetchingInternetStatus.connected,
    this.userCurrentLat = 0.0,
    this.userCurrentLong = 0.0,
    this.vpnList = const [],
    this.selectedVpn = const Vpn.empty(),
  });
  final FetchingIpAp fetchingIpAp;
  final FetchingAvailableServers fetchingAvailableServers;
  final FetchingInternetStatus fetchingInternetStatus;
  final double userCurrentLat;
  final double userCurrentLong;
  final List<Vpn> vpnList;
  final Vpn selectedVpn;

  VpnStateHolder copyWith({
    FetchingIpAp? fetchingIpApi,
    FetchingAvailableServers? fetchingAvailableServers,
    FetchingInternetStatus? fetchingInternetStatus,
    double? userCurrentLat,
    double? userCurrentLong,
    List<Vpn>? vpnList,
    Vpn? selectedVpn,
  }) {
    return VpnStateHolder(
        fetchingIpAp: fetchingIpApi ?? fetchingIpAp,
        fetchingAvailableServers:
            fetchingAvailableServers ?? this.fetchingAvailableServers,
        fetchingInternetStatus:
            fetchingInternetStatus ?? this.fetchingInternetStatus,
        userCurrentLat: userCurrentLat ?? this.userCurrentLat,
        userCurrentLong: userCurrentLong ?? this.userCurrentLong,
        vpnList: vpnList ?? this.vpnList,
        selectedVpn: selectedVpn ?? this.selectedVpn);
  }

  @override
  List<Object?> get props => [
        fetchingIpAp,
        fetchingAvailableServers,
        fetchingInternetStatus,
        userCurrentLat,
        userCurrentLong,
        vpnList,
        selectedVpn
      ];
}
