import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/cubit/map_cubit.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/app_main_screen_bottom_sheet.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/extracted_widget.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/optimized_drawer.dart';

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
    return AdvancedDrawer(
      backdrop: const AdvanceDrawerBackDrop(),
      controller: context.read<VpnBloc>().drawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: const OptimizedDrawer(),
      child: Scaffold(
        appBar: ConstAppBar(
          state: context.read<VpnBloc>().state,
          methodToOpenDrawer: () {
            context.read<VpnBloc>().drawerController.showDrawer();
          },
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            BlocBuilder<MapCubit, MapState>(
              buildWhen: (previous, current) =>
                  previous.markers != current.markers ||
                  previous.cameraPosition.target !=
                      current.cameraPosition.target,
              builder: (context, mapState) {
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
                      context.read<MapCubit>().setMapController(controller);
                    } else {
                      controller.dispose();
                    }
                  },
                );
              },
            ),
            const ServerUnReachBlinkText(),
            const LocationTrackableBlink(),
          ],
        ),
        bottomSheet: const AppMainScreenBottomSheet(),
      ),
    );
  }
}
