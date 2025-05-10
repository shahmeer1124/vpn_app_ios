import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:openvpn_flutter_example/core/errors/exceptions.dart';
import 'package:openvpn_flutter_example/core/utils/typedefs.dart';
import 'package:openvpn_flutter_example/src/vpn/data/models/ip_detail_model.dart';
import 'package:openvpn_flutter_example/src/vpn/data/models/vpn_detail_model.dart';

abstract class VpnDataSource {
  const VpnDataSource();
  Future<IpDetailModel> getUserLocation();
  Future<List<VpnDetailModel>> getAvailableVpnList();
}

class VpnDataSrcImpl implements VpnDataSource {
  @override
  Future<IpDetailModel> getUserLocation() async {
    print('get user location called');
    final uri = Uri.parse(UrlSavePlace.apiIpUrl);
    try {
      final response = await get(uri).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          throw const ServerException(
            message: 'Server timed out after 5 seconds',
            statusCode: '408',
          );
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return IpDetailModel.fromJson(data as DataMap);
      } else {
        throw const ServerException(
          message: 'Server is not accessible',
          statusCode: '404',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(
        message: 'Server is not accessible',
        statusCode: '404',
      );
    }
  }

  @override
  Future<List<VpnDetailModel>> getAvailableVpnList() async {
    final uri = Uri.parse(UrlSavePlace.serverUrl);
    final vpnList = <VpnDetailModel>[];
    try {
      final response = await get(uri);
      if (kDebugMode) {
        print(response.statusCode);
      }
      final csvString = response.body.split('#')[1].replaceAll('*', '');
      final list = const CsvToListConverter().convert(csvString);
      final header = list[0];
      for (var i = 1; i < list.length - 1; ++i) {
        final tempJson = <String, dynamic>{};

        for (var j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(VpnDetailModel.fromJson(tempJson));
      }
      vpnList.shuffle();
      return vpnList;
    } catch (e) {
      throw const ServerException(
          message: 'Server is not accessible', statusCode: '404');
    }
  }
}
