import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openvpn_flutter_example/core/extensions/context_extension.dart';
import 'package:openvpn_flutter_example/core/services/injection_container_main.dart';
import 'package:openvpn_flutter_example/core/services/router/router.dart';
import 'package:openvpn_flutter_example/global_initializer.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializerClass.initItems();
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
        child: const MaterialApp(
          onGenerateRoute: onGenerateRoute,
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late OpenVPN engine;
//   VpnStatus? status;
//   String? stage;
//   bool _granted = false;
//   // @override
//   // void initState() {
//   //   engine = OpenVPN(
//   //     onVpnStatusChanged: (data) {
//   //       setState(() {
//   //         status = data;
//   //       });
//   //     },
//   //     onVpnStageChanged: (data, raw) {
//   //       setState(() {
//   //         stage = raw;
//   //       });
//   //     },
//   //   );
//   //
//   //   engine.initialize(
//   //     groupIdentifier: "group.checksum.com.lockScreenWidget",
//   //     providerBundleIdentifier: "com.vpn.iosapplicationexample.VPNExtension",
//   //     localizedDescription: "VPN by Nizwar",
//   //     lastStage: (stage) {
//   //       setState(() {
//   //         this.stage = stage.name;
//   //       });
//   //     },
//   //     lastStatus: (status) {
//   //       setState(() {
//   //         this.status = status;
//   //       });
//   //     },
//   //   );
//   //   super.initState();
//   // }
//   //
//   // Future<void> initPlatformState() async {
//   //   engine.connect(
//   //     await rootBundle.loadString('assets/test_file.ovpn'),
//   //     "USA",
//   //     username: defaultVpnUsername,
//   //     password: defaultVpnPassword,
//   //     certIsRequired: true,
//   //   );
//   //   if (!mounted) return;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: MapSample()
//
//         // Scaffold(
//         //   appBar: AppBar(
//         //     title: const Text('Plugin example app'),
//         //   ),
//         //   body: Center(
//         //     child: Column(
//         //       mainAxisSize: MainAxisSize.min,
//         //       children: [
//         //         Text(stage?.toString() ?? VPNStage.disconnected.toString()),
//         //         Text(status?.toJson().toString() ?? ""),
//         //         TextButton(
//         //           child: const Text("Start"),
//         //           onPressed: () {
//         //             // APIs.getVPNServers();
//         //             initPlatformState();
//         //           },
//         //         ),
//         //         TextButton(
//         //           child: const Text("STOP"),
//         //           onPressed: () {
//         //             engine.disconnect();
//         //           },
//         //         ),
//         //         if (Platform.isAndroid)
//         //           TextButton(
//         //             child: Text(_granted ? "Granted" : "Request Permission"),
//         //             onPressed: () {
//         //               engine.requestPermissionAndroid().then((value) {
//         //                 setState(() {
//         //                   _granted = value;
//         //                 });
//         //               });
//         //             },
//         //           ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//         );
//   }
// }
//
// const String defaultVpnUsername = "vpn";
// const String defaultVpnPassword = "vpn";
//
// String get config => "HERE IS YOUR OVPN SCRIPT";
