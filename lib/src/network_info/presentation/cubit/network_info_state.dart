part of 'network_info_cubit.dart';


enum NetworkInfoStatus { initial, loading, loaded, error }

class NetworkInfoState extends Equatable {
  NetworkInfoState({
    required this.wifiName,
    required this.wifiBSSID,
    required this.wifiIP,
    required this.wifiIPv6,
    required this.wifiSubmask,
    required this.wifiBroadcast,
    required this.wifiGateway,
    required this.permissionStatus,
    required this.status,
    this.errorMessage,
  });

  factory NetworkInfoState.initial() => NetworkInfoState(
    wifiName: null,
    wifiBSSID: null,
    wifiIP: null,
    wifiIPv6: null,
    wifiSubmask: null,
    wifiBroadcast: null,
    wifiGateway: null,
    permissionStatus: PermissionStatus.denied,
    status: NetworkInfoStatus.initial,
  );

  final String? wifiName;
  final String? wifiBSSID;
  final String? wifiIP;
  final String? wifiIPv6;
  final String? wifiSubmask;
  final String? wifiBroadcast;
  final String? wifiGateway;
  final PermissionStatus permissionStatus;
  final NetworkInfoStatus status;
  final String? errorMessage;

  NetworkInfoState copyWith({
    String? wifiName,
    String? wifiBSSID,
    String? wifiIP,
    String? wifiIPv6,
    String? wifiSubmask,
    String? wifiBroadcast,
    String? wifiGateway,
    PermissionStatus? permissionStatus,
    NetworkInfoStatus? status,
    String? errorMessage,
  }) {
    return NetworkInfoState(
      wifiName: wifiName ?? this.wifiName,
      wifiBSSID: wifiBSSID ?? this.wifiBSSID,
      wifiIP: wifiIP ?? this.wifiIP,
      wifiIPv6: wifiIPv6 ?? this.wifiIPv6,
      wifiSubmask: wifiSubmask ?? this.wifiSubmask,
      wifiBroadcast: wifiBroadcast ?? this.wifiBroadcast,
      wifiGateway: wifiGateway ?? this.wifiGateway,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    wifiName,
    wifiBSSID,
    wifiIP,
    wifiIPv6,
    wifiSubmask,
    wifiBroadcast,
    wifiGateway,
    permissionStatus,
    status,
    errorMessage,
  ];
}
