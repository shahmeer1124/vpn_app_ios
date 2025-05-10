import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/avl_server_list.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/blinking_text_widget.dart';
import 'package:uicons_pro/uicons_pro.dart';

class LeftColumnText extends StatelessWidget {
  const LeftColumnText({
    required this.text,
    required this.color,
    required this.fontSize,
    super.key,
  });
  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      child: Text(
        text,
        style: appstyle(fontSize, color, FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final double width;

  const StatusRow({
    Key? key,
    required this.icon,
    required this.value,
    required this.color,
    this.width = 46,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 8,
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              value,
              style: appstyle(
                8,
                color,
                FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ConstantDivider extends StatelessWidget {
  const ConstantDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: context.width * 0.05,
          height: 2,
          color: Colors.white.withValues(alpha: 0.1),
        )
      ],
    );
  }
}

class SelectedServerInfoTile extends StatelessWidget {
  const SelectedServerInfoTile({super.key, required this.state});
  final VpnStateHolder state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.width * 0.65,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1), width: 2))),
          height: 100,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 18, right: 13),
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: ClipOval(
                    child: Container(
                      height: 47, // Half of the outer container size
                      width: 47, // Half of the outer container size
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // Ensure circular shape
                      ),
                      child: Transform.scale(
                        scale: 1.63,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://flagsapi.com/${state.selectedVpn.countryShort}/shiny/64.png',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  const CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.27,
                        child: Text(
                          state.selectedVpn.countryLong,
                          style: appstyle(12, Colors.white, FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      BlocBuilder<VpnBloc, VpnStateHolder>(
                        builder: (context, state) {
                          return CountryMenuButton(
                            vpnStateHolder: state,
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        UIconsPro.solidRounded.internet_speed_wifi,
                        color: getSpeedColor(state.selectedVpn.speed / 1000000),
                        size: 13,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${(state.selectedVpn.speed / 1000000).toStringAsFixed(0)} Mbps',
                        style: appstyle(
                            13,
                            getSpeedColor(state.selectedVpn.speed / 1000000),
                            FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        UIconsPro.solidRounded.wifi,
                        color: Colors.green,
                        size: 13,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${state.selectedVpn.ping} ms',
                        style: appstyle(13, Colors.green, FontWeight.w400),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 28, top: 30),
          width: context.width * 0.65,
          child: Row(
            children: [
              Transform.rotate(
                angle: -1.55,
                child: Transform.scale(
                  scale: 1.2,
                  child: CupertinoSwitch(
                      value: state.smartestServerSelection ==
                          SmartestServerSelection.connected,
                      onChanged: (val) {
                        context
                            .read<VpnBloc>()
                            .add(SelectSmartServer(context: context));
                      }),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Location',
                    style: appstyle(18, Colors.white, FontWeight.w500),
                  ),
                  Text(
                    'Fastest Server',
                    style: appstyle(12, Colors.white.withValues(alpha: 0.5),
                        FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class ConstAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConstAppBar(
      {super.key, required this.state, required this.methodToOpenDrawer});
  final VpnStateHolder state;
  final VoidCallback methodToOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: methodToOpenDrawer,
        child: Icon(
          UIconsPro.solidRounded.menu_burger,
          color: ColorsConstants.mainBodyBgColor,
          size: 25,
        ),
      ),
      title: BlocBuilder<VpnBloc, VpnStateHolder>(
        builder: (context, state) {
          bool isConnected = state.vpnStage.toLowerCase() == 'connected';
          return Text(
            '${state.vpnStatus?.duration}',
            style: appstyle(
                25,
                isConnected ? Colors.green : ColorsConstants.mainBodyBgColor,
                FontWeight.w600),
          );
        },
      ),
      actions: [
        BlocBuilder<VpnBloc, VpnStateHolder>(
          builder: (context, state) {
            bool isConnected = state.vpnStage.toLowerCase() == 'connected';
            bool isConnecting = state.vpnStage.toLowerCase() == 'connecting';
            return Row(
              children: [
                Text(
                  state.vpnStage.toUpperCase(),
                  style: appstyle(
                      13,
                      isConnecting
                          ? Colors.yellow
                          : isConnected
                              ? Colors.green
                              : Colors.red,
                      FontWeight.w700),
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  isConnecting
                      ? UIconsPro.solidRounded.plug_connection
                      : isConnected
                          ? Icons.security
                          : CupertinoIcons.nosign,
                  color: isConnecting
                      ? Colors.yellow
                      : isConnected
                          ? Colors.green
                          : Colors.red,
                  size: 15,
                ),
                const SizedBox(
                  width: 3,
                ),
              ],
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class LocationTrackableBlink extends StatelessWidget {
  const LocationTrackableBlink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VpnBloc, VpnStateHolder>(
      builder: (context, state) {
        return Visibility(
          visible: state.fetchingIpAp == FetchingIpAp.error,
          maintainAnimation: false,
          maintainSize: false,
          maintainState: false,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 25, top: 10),
              child: BlinkingText(
                'Your location appears only if the VPN server is detectable.',
                style: appstyle(12, Colors.red, FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ServerUnReachBlinkText extends StatelessWidget {
  const ServerUnReachBlinkText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VpnBloc, VpnStateHolder>(
      builder: (context, state) {
        return Visibility(
          visible:
              state.showServerIsSlowMessage == ShowServerIsSlowMessage.show,
          maintainAnimation: false,
          maintainSize: false,
          maintainState: false,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 25, top: 10),
              child: BlinkingText(
                'Server unreachable or experiencing high traffic. Please try another server.',
                style: appstyle(12, Colors.red, FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}
