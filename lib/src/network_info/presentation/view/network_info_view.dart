import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openvpn_flutter_example/src/network_info/presentation/cubit/network_info_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkInfoScreen extends StatelessWidget {
  const NetworkInfoScreen({super.key});
  static const routeName = '/network_info';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NetworkInfoCubit>()..fetchNetworkInfo(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Network Information'),
        ),
        body: BlocBuilder<NetworkInfoCubit, NetworkInfoState>(
          builder: (context, state) {
            if (state.status == NetworkInfoStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == NetworkInfoStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.errorMessage ?? "Unknown error"}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<NetworkInfoCubit>().fetchNetworkInfo(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NetworkInfoCubit>().fetchNetworkInfo(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard('Wi-Fi Name', state.wifiName ?? 'N/A'),
                    _buildInfoCard('Wi-Fi BSSID', state.wifiBSSID ?? 'N/A'),
                    _buildInfoCard('Wi-Fi IP', state.wifiIP ?? 'N/A'),
                    _buildInfoCard('Wi-Fi IPv6', state.wifiIPv6 ?? 'N/A'),
                    _buildInfoCard('Wi-Fi Submask', state.wifiSubmask ?? 'N/A'),
                    _buildInfoCard(
                        'Wi-Fi Broadcast', state.wifiBroadcast ?? 'N/A'),
                    _buildInfoCard('Wi-Fi Gateway', state.wifiGateway ?? 'N/A'),
                    _buildInfoCard('Permission Status',
                        state.permissionStatus.toString().split('.').last),
                    if (state.permissionStatus != PermissionStatus.granted)
                      ElevatedButton(
                        onPressed: () => context
                            .read<NetworkInfoCubit>()
                            .requestPermissions(),
                        child: const Text('Request Permissions'),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
