import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/core/res/media_res.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/app_main_screen.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/avl_server_list.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activateFirstCallToGetUserEstimatedLocation();
    });
  }

  void activateFirstCallToGetUserEstimatedLocation() {
    dispatchVpnEvent(context, const GetUserLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return

        //   Container(
        //   height: context.height,
        //   width: context.width,
        //   child: Center(
        //     child: CustomMarkerWidget(),
        //   ),
        // );

        BlocConsumer<VpnBloc, VpnStateHolder>(
      listenWhen: (prev, current) {
        return (current.fetchingIpAp == FetchingIpAp.fetched &&
                prev.fetchingIpAp != FetchingIpAp.fetched) ||
            (current.fetchingAvailableServers ==
                    FetchingAvailableServers.fetched &&
                prev.fetchingAvailableServers !=
                    FetchingAvailableServers.fetched);
      },
      listener: (context, state) {
        if (state.fetchingAvailableServers ==
                FetchingAvailableServers.fetched &&
            state.fetchingIpAp == FetchingIpAp.fetched) {
          Navigator.of(context).pushReplacementNamed(VpnMainView.routeName);
        } else if (state.fetchingIpAp == FetchingIpAp.fetched) {
          dispatchVpnEvent(context, const GetAvailableServerListEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: ColorsConstants.mainBodyBgColor,
            appBar: AppBar(
              backgroundColor: ColorsConstants.mainBodyBgColor,
              title: Text(
                'VPN Shield',
                style: appstyle(
                  19,
                  Colors.white,
                  FontWeight.w700,
                ),
              ),
            ),
            body: Container(
              height: context.height,
              width: context.width,
              decoration: BoxDecoration(color: ColorsConstants.mainBodyBgColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(MediaRes.splashLoaderAnimation),
                  Text(
                    state.fetchingIpAp == FetchingIpAp.fetching &&
                            state.fetchingAvailableServers !=
                                FetchingAvailableServers.fetched
                        ? 'Getting your current location on internet'
                        : state.fetchingAvailableServers ==
                                FetchingAvailableServers.fetching
                            ? 'Just a moment — Fetching available servers!'
                            : state.fetchingIpAp == FetchingIpAp.fetched &&
                                    state.fetchingAvailableServers ==
                                        FetchingAvailableServers.fetched
                                ? 'Initialization Complete'
                                : 'Initializing your VPN',
                    style: appstyle(16, Colors.white, FontWeight.w500),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

void dispatchVpnEvent(BuildContext context, VpnEvent event) {
  print('Dispatching event: ${event.runtimeType}, time: ${DateTime.now()}');
  context.read<VpnBloc>().add(event);
}
