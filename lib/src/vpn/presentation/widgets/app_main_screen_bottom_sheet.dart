import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/extracted_widget.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/personal_real_button.dart';

class AppMainScreenBottomSheet extends StatelessWidget {
  const AppMainScreenBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VpnBloc, VpnStateHolder>(
      builder: (context, state) {
        final isConnected = state.vpnStage.toLowerCase() == 'connected';
        bool isConnecting = state.vpnStage.toLowerCase() == 'connecting';
        return Container(
          padding: const EdgeInsets.only(top: 2, bottom: 15),
          height: 235,
          width: context.width,
          decoration: BoxDecoration(
            color: ColorsConstants.mainBodyBgColor,
            // color: Colors.black.withValues(alpha: 0.6),
            borderRadius: const BorderRadius.only(

              topLeft: Radius.circular(35),
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
                      isConnecting
                          ? Colors.yellow
                          : state.vpnStage.toLowerCase() == 'connected'
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
    );
  }
}

String _formatBytesToMB(dynamic bytes) {
  if (bytes == null) return "0.00";
  double bytesValue = double.tryParse(bytes.toString()) ?? 0.0;
  double mb = bytesValue / (1024 * 1024);
  return mb.toStringAsFixed(2);
}
