import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/cubit/map_cubit.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/avl_server_list.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/extracted_widget.dart';
import 'package:realistic_button/realistic_button.dart';
import 'package:uicons_pro/uicons_pro.dart';

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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        leading: Icon(
          UIconsPro.solidRounded.menu_burger,
          color: Colors.white,
          size: 25,
        ),
        title: Text(
          '00:12:24',
          style: appstyle(25, Colors.white, FontWeight.w600),
        ),
        actions: [
          Text(
            'Not Connected',
            style: appstyle(13, Colors.yellow, FontWeight.w700),
          ),
          const SizedBox(
            width: 3,
          ),
          const Icon(
            Icons.dangerous_rounded,
            color: Colors.yellow,
          ),
          const SizedBox(
            width: 3,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<MapCubit, MapState>(
        buildWhen: (previous, current) =>
            previous.markers != current.markers ||
            previous.cameraPosition.target != current.cameraPosition.target,
        builder: (context, state) {
          if (state.markers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            key: _mapKey,
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.hybrid,
            initialCameraPosition: state.cameraPosition,
            markers: state.markers,
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
          return Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              height: 230,
              width: context.width,
              decoration: BoxDecoration(
                  color: ColorsConstants.mainBodyBgColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(28),
                      topLeft: Radius.circular(28))),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: context.width * 0.65,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 2))),
                        height: 100,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 18, right: 13),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2)),
                              child: Center(
                                child: Icon(UIconsPro.boldRounded.german),
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
                                        style: appstyle(
                                            12, Colors.white, FontWeight.w600),
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
                                      UIconsPro
                                          .solidRounded.internet_speed_wifi,
                                      color: getSpeedColor(
                                          state.selectedVpn.speed / 1000000),
                                      size: 13,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${(state.selectedVpn.speed / 1000000).toStringAsFixed(0)} Mbps',
                                      style: appstyle(
                                          13,
                                          getSpeedColor(
                                              state.selectedVpn.speed /
                                                  1000000),
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
                                      style: appstyle(
                                          13, Colors.green, FontWeight.w400),
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
                                    value: false, onChanged: (val) {}),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Smart Location',
                                  style: appstyle(
                                      18, Colors.white, FontWeight.w500),
                                ),
                                Text(
                                  'Fastest Server',
                                  style: appstyle(
                                      12,
                                      Colors.white.withValues(alpha: 0.5),
                                      FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  RealisticButton(
                    size: context.width * 0.30,
                    onchange: (val) {
                      // setState(() {
                      //   // _buttonStatus = val;
                      // });
                    },
                    label: "Start/Stop",
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: context.width * 0.05,
                        height: 2,
                         color: Colors.white.withValues(alpha: 0.1),
                      )
                    ],
                  )
                ],
              ));
        },
      ),
    );
  }
}
