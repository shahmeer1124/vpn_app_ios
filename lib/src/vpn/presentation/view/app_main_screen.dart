import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/cubit/map_cubit.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/extracted_widget.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/personal_real_button.dart';

class VpnMainView extends StatefulWidget {
  const VpnMainView({super.key});

  static const routeName = '/vpn_main_view';

  @override
  State<VpnMainView> createState() => _VpnMainViewState();
}

class _VpnMainViewState extends State<VpnMainView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  final _mapKey = UniqueKey();
  late OpenVPN engine;

  Future<void> initPlatformState(Vpn model) async {
    final data = const Base64Decoder().convert(model.openVPNConfigDataBase64);
    final config = const Utf8Decoder().convert(data);
    await engine.connect(
      config,
      "USA",
      username: 'vpn',
      password: 'vpn',
      certIsRequired: true,
    );
    if (!mounted) return;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstAppBar(
        state: context.read<VpnBloc>().state,
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<MapCubit, MapState>(
        buildWhen: (previous, current) =>
            previous.markers != current.markers ||
            previous.cameraPosition.target != current.cameraPosition.target,
        builder: (context, mapState) {
          if (mapState.markers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            key: _mapKey,
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.terrain,
            initialCameraPosition: mapState.cameraPosition,
            markers: mapState.markers,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
                _mapController = controller;
              } else {
                controller.dispose();
              }
            },
          );
        },
      ),
      bottomSheet: BlocBuilder<VpnBloc, VpnStateHolder>(
        builder: (context, state) {
          final isConnected = state.vpnStage.toLowerCase() == 'connected';
          return Container(
            padding: const EdgeInsets.only(top: 2, bottom: 15),
            height: 235,
            width: context.width,
            decoration: BoxDecoration(
              color: ColorsConstants.mainBodyBgColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(28),
                topLeft: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Status: ${state.vpnStage.toUpperCase()} | '
                    'Received: ${state.vpnStage.toLowerCase() == 'disconnected' ? '0.00' : _formatBytesToMB(state.vpnStatus?.byteIn)} MB, '
                    'Sent: ${state.vpnStage.toLowerCase() == 'disconnected' ? '0.00' : _formatBytesToMB(state.vpnStatus?.byteOut)} MB',
                    style: appstyle(
                        10,
                        state.vpnStage.toLowerCase() == 'connected'
                            ? Colors.green
                            : Colors.red,
                        FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectedServerInfoTile(state: state),
                    BlocBuilder<VpnBloc, VpnStateHolder>(
                      builder: (context, state) {
                        final isConnected =
                            state.vpnStage.toLowerCase() == 'connected';
                        final isConnecting =
                            state.vpnStage.toLowerCase() == 'connecting';
                        return Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: PersonalRealisticButton(
                            size: MediaQuery.of(context).size.width * 0.3,
                            onchange: (val) {
                              if (isConnecting) {
                                print('Cancelling connection');
                                context
                                    .read<VpnBloc>()
                                    .add(const DisconnectVpn());
                              } else if (val) {
                                print('Initiating connection');
                                context
                                    .read<VpnBloc>()
                                    .add(ConnectVpn(context: context));
                              } else {
                                print('Disconnecting VPN');
                                context
                                    .read<VpnBloc>()
                                    .add(const DisconnectVpn());
                              }
                            },
                            label: isConnecting
                                ? 'Connecting...'
                                : isConnected
                                    ? 'Disconnect'
                                    : 'Connect',
                            isActive: isConnected,
                          ),
                        );
                      },
                    ),
                    const ConstantDivider(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _formatBytesToMB(dynamic bytes) {
  if (bytes == null) return "0.00";
  double bytesValue = double.tryParse(bytes.toString()) ?? 0.0;
  double mb = bytesValue / (1024 * 1024);
  return mb.toStringAsFixed(2);
}
