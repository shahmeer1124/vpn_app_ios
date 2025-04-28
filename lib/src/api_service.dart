// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:csv/csv.dart';
//
// import 'package:http/http.dart';
//
//
//
// import '../model.dart';
//
//
// class APIs {
//   static Future<List<Vpn>> getVPNServers() async {
//     final List<Vpn> vpnList = [];
//
//     try {
//       final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
//       final csvString = res.body.split("#")[1].replaceAll('*', '');
//
//       List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
//
//       final header = list[0];
//
//       for (int i = 1; i < list.length - 1; ++i) {
//         Map<String, dynamic> tempJson = {};
//
//         for (int j = 0; j < header.length; ++j) {
//           tempJson.addAll({header[j].toString(): list[i][j]});
//         }
//         vpnList.add(Vpn.fromJson(tempJson));
//
//       }
//       log(vpnList[0].openVPNConfigDataBase64);
//     } catch (e) {
//       log('\ngetVPNServersE: $e');
//     }
//     vpnList.shuffle();
//
//
//
//     return vpnList;
//   }
//
//   // static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
//   //   try {
//   //     final res = await get(Uri.parse('http://ip-api.com/json/'));
//   //     final data = jsonDecode(res.body);
//   //     log(data.toString());
//   //     ipData.value = IPDetails.fromJson(data);
//   //   } catch (e) {
//   //     MyDialogs.error(msg: e.toString());
//   //     log('\ngetIPDetailsE: $e');
//   //   }
//   // }
// }
//
// // Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36
//
// // For Understanding Purpose
//
// //*** CSV Data ***
// // Name,    Country,  Ping
// // Test1,   JP,       12
// // Test2,   US,       112
// // Test3,   IN,       7
//
// //*** List Data ***
// // [ [Name, Country, Ping], [Test1, JP, 12], [Test2, US, 112], [Test3, IN, 7] ]
//
// //*** Json Data ***
// // {"Name": "Test1", "Country": "JP", "Ping": 12}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
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
//   @override
//   void initState() {
//     engine = OpenVPN(
//       onVpnStatusChanged: (data) {
//         setState(() {
//           status = data;
//         });
//       },
//       onVpnStageChanged: (data, raw) {
//         setState(() {
//           stage = raw;
//         });
//       },
//     );
//
//     engine.initialize(
//       groupIdentifier: "group.checksum.com.lockScreenWidget",
//       providerBundleIdentifier: "com.vpn.iosapplicationexample.VPNExtension",
//       localizedDescription: "VPN by Nizwar",
//       lastStage: (stage) {
//         setState(() {
//           this.stage = stage.name;
//         });
//       },
//       lastStatus: (status) {
//         setState(() {
//           this.status = status;
//         });
//       },
//     );
//     super.initState();
//   }
//
//   Future<void> initPlatformState() async {
//     engine.connect(
//       await rootBundle.loadString('assets/test_file.ovpn'),
//       "USA",
//       username: defaultVpnUsername,
//       password: defaultVpnPassword,
//       certIsRequired: true,
//     );
//     if (!mounted) return;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//
//         Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(stage?.toString() ?? VPNStage.disconnected.toString()),
//                 Text(status?.toJson().toString() ?? ""),
//                 TextButton(
//                   child: const Text("Start"),
//                   onPressed: () {
//                     // APIs.getVPNServers();
//                     initPlatformState();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text("STOP"),
//                   onPressed: () {
//                     engine.disconnect();
//                   },
//                 ),
//                 if (Platform.isAndroid)
//                   TextButton(
//                     child: Text(_granted ? "Granted" : "Request Permission"),
//                     onPressed: () {
//                       engine.requestPermissionAndroid().then((value) {
//                         setState(() {
//                           _granted = value;
//                         });
//                       });
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ),
//         );
//   }
// }
//
// const String defaultVpnUsername = "vpn";
// const String defaultVpnPassword = "vpn";
//
// String get config => "HERE IS YOUR OVPN SCRIPT";