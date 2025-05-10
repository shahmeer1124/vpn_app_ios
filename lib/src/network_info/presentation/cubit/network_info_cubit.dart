import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
part 'network_info_state.dart';


class NetworkInfoCubit extends Cubit<NetworkInfoState> {
  final NetworkInfo _networkInfo;

  NetworkInfoCubit(this._networkInfo) : super(NetworkInfoState.initial());

  Future<void> fetchNetworkInfo() async {
    emit(state.copyWith(status: NetworkInfoStatus.loading));
    try {
      final permissionStatus = await _checkAndRequestPermissions();
      if (permissionStatus != PermissionStatus.granted) {
        emit(state.copyWith(
          permissionStatus: permissionStatus,
          status: NetworkInfoStatus.loaded,
          errorMessage: permissionStatus == PermissionStatus.permanentlyDenied
              ? 'Location permission is permanently denied. Please enable it in Settings.'
              : 'Location permission is required to access Wi-Fi information.',
        ));
        return;
      }

      final wifiName = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiIPv6 = await _networkInfo.getWifiIPv6();
      final wifiSubmask = await _networkInfo.getWifiSubmask();
      final wifiBroadcast = await _networkInfo.getWifiBroadcast();
      final wifiGateway = await _networkInfo.getWifiGatewayIP();

      emit(state.copyWith(
        wifiName: wifiName,
        wifiBSSID: wifiBSSID,
        wifiIP: wifiIP,
        wifiIPv6: wifiIPv6,
        wifiSubmask: wifiSubmask,
        wifiBroadcast: wifiBroadcast,
        wifiGateway: wifiGateway,
        permissionStatus: permissionStatus,
        status: NetworkInfoStatus.loaded,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NetworkInfoStatus.error,
        errorMessage: 'Failed to fetch network info: $e',
      ));
    }
  }

  Future<void> requestPermissions() async {
    final status = await _checkAndRequestPermissions();
    emit(state.copyWith(
      permissionStatus: status,
      status: NetworkInfoStatus.loaded,
      errorMessage: status == PermissionStatus.permanentlyDenied
          ? 'Location permission is permanently denied. Please enable it in Settings.'
          : null,
    ));
    if (status == PermissionStatus.granted) {
      await fetchNetworkInfo();
    }
  }

  Future<PermissionStatus> _checkAndRequestPermissions() async {
    try {
      PermissionStatus status = await Permission.locationWhenInUse.status;
      if (!status.isGranted && !status.isPermanentlyDenied) {
        status = await Permission.locationWhenInUse .request();
      }
      return status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }
}
