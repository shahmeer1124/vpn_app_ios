import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';

class VpnDetailModel extends Vpn {
  VpnDetailModel(
      {required super.hostname,
      required super.ip,
      required super.ping,
      required super.speed,
      required super.countryLong,
      required super.countryShort,
      required super.numVpnSessions,
      required super.openVPNConfigDataBase64});

  factory VpnDetailModel.fromJson(Map<String, dynamic> json) {
    return VpnDetailModel(
      hostname: json['HostName']?.toString() ?? '',
      ip: json['IP']?.toString() ?? '',
      ping: json['Ping']?.toString() ?? '',
      speed: (json['Speed'] as num?)?.toInt() ?? 0,
      countryLong: json['CountryLong']?.toString() ?? '',
      countryShort: json['CountryShort']?.toString() ?? '',
      numVpnSessions: (json['NumVpnSessions'] as num?)?.toInt() ?? 0,
      openVPNConfigDataBase64:
          json['OpenVPN_ConfigData_Base64']?.toString() ?? '',
    );
  }
}
