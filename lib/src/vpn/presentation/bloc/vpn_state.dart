part of 'vpn_bloc.dart';

enum FetchingIpAp { initial, fetching, fetched, error }

enum FetchingAvailableServers { initial, fetching, fetched, error }

enum FetchingInternetStatus { connected, disconnected }

enum SmartestServerSelection { initial, connected }

enum ShowServerIsSlowMessage { initial, show, hide }

enum Sorting { initial, sorting, sorted }

class VpnStateHolder extends Equatable {
  const VpnStateHolder({
    this.fetchingAvailableServers = FetchingAvailableServers.initial,
    this.fetchingIpAp = FetchingIpAp.initial,
    this.fetchingInternetStatus = FetchingInternetStatus.connected,
    this.userCurrentLat = 0.0,
    this.userCurrentLong = 0.0,
    this.vpnList = const [],
    this.selectedVpn = const Vpn.empty(),
    this.vpnStage = 'disconnected',
    this.vpnStatus,
    this.filterType,
    this.isAndroidPermissionGranted = false,
    this.smartestServerSelection = SmartestServerSelection.initial,
    this.showServerIsSlowMessage = ShowServerIsSlowMessage.initial,
    this.sorting = Sorting.initial,
  });
  final FetchingIpAp fetchingIpAp;
  final FetchingAvailableServers fetchingAvailableServers;
  final FetchingInternetStatus fetchingInternetStatus;
  final double userCurrentLat;
  final double userCurrentLong;
  final List<Vpn> vpnList;
  final Vpn selectedVpn;
  final String vpnStage;
  final VpnStatus? vpnStatus;
  final FilterType? filterType;
  final bool isAndroidPermissionGranted;
  List<Vpn> get sortedVpn => (filterType ?? FilterType.lowestConnections)
      .applyAll(vpnList, filterType ?? FilterType.lowestConnections);
  final SmartestServerSelection smartestServerSelection;
  final ShowServerIsSlowMessage showServerIsSlowMessage;
  final Sorting sorting;

  VpnStateHolder copyWith({
    FetchingIpAp? fetchingIpApi,
    FetchingAvailableServers? fetchingAvailableServers,
    FetchingInternetStatus? fetchingInternetStatus,
    double? userCurrentLat,
    double? userCurrentLong,
    List<Vpn>? vpnList,
    Vpn? selectedVpn,
    String? vpnStage,
    VpnStatus? vpnStatus,
    bool? isAndroidPermissionGranted,
    FilterType? filteringType,
    SmartestServerSelection? smartServerSelection,
    ShowServerIsSlowMessage? showServerIsSlow,
    Sorting? sortingStart,
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
        selectedVpn: selectedVpn ?? this.selectedVpn,
        vpnStage: vpnStage ?? this.vpnStage,
        vpnStatus: vpnStatus ?? this.vpnStatus,
        isAndroidPermissionGranted:
            isAndroidPermissionGranted ?? this.isAndroidPermissionGranted,
        smartestServerSelection:
            smartServerSelection ?? smartestServerSelection,
        showServerIsSlowMessage: showServerIsSlow ?? showServerIsSlowMessage,
        sorting: sortingStart ?? sorting,
        filterType: filteringType ?? filterType);
  }

  @override
  List<Object?> get props => [
        fetchingIpAp,
        fetchingAvailableServers,
        fetchingInternetStatus,
        userCurrentLat,
        userCurrentLong,
        vpnList,
        selectedVpn,
        vpnStage,
        vpnStatus,
        isAndroidPermissionGranted,
        smartestServerSelection,
        showServerIsSlowMessage,
        sorting,
        filterType
      ];
}
