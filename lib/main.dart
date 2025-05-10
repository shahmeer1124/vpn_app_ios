import 'dart:io';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:network_tools/network_tools.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/services/injection_container_main.dart';
import 'package:openvpn_flutter_example/core/services/router/router.dart';
import 'package:openvpn_flutter_example/global_initializer.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/splash_view.dart';
import 'package:path_provider/path_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializerClass.initItems();
  final appDocDirectory = await getApplicationDocumentsDirectory();
  await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
  DartPingIOS.register();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<VpnBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(context.width, context.height),
        child: MaterialApp(
          theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,

              ),
            ),
          ),
          onGenerateRoute: onGenerateRoute,
          debugShowCheckedModeBanner: false,
          home: const SplashView(),
        ),
      ),
    );
  }
}

