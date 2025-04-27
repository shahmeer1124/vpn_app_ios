import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/cubit/map_cubit.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/app_main_screen.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case VpnMainView.routeName:
      return CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => MapCubit(vpnBloc: context.read<VpnBloc>()),
          child: const VpnMainView(),
        ),
      );

    default:
      return _pageBuilder(
        (context) {
          return const SplashView();
        },
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, __) => page(context),
    transitionsBuilder: (context, _, __, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      // final tween =
      //     Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return child;
      //   SlideTransition(
      //   // position: animation.drive(tween),
      //   child: child,
      // );
    },
    // transitionDuration: const Duration(milliseconds: 600),
  );
}

// class MethodForNavigationHelping {
//   static void methodForNavigation(int index, BuildContext context) {
//     Future.delayed(Duration.zero, () {
//       Navigator.of(context).pushNamed(NavigationRoutes.paths[index]);
//     });
//   }
//
//   static void methodForPopAndPushNavigation(int index, BuildContext context) {
//     Future.delayed(Duration.zero, () {
//       Navigator.of(context).popAndPushNamed(NavigationRoutes.paths[index]);
//     });
//   }
// }
