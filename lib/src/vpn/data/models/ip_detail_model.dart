import 'package:openvpn_flutter_example/src/vpn/domain/entities/ip_detail_entity.dart';

class IpDetailModel extends IPDetails {
  IpDetailModel({
    required super.status,
    required super.country,
    required super.countryCode,
    required super.region,
    required super.regionName,
    required super.city,
    required super.zip,
    required super.lat,
    required super.lon,
    required super.timezone,
    required super.isp,
    required super.org,
    required super.as,
    required super.query,
  });

  factory IpDetailModel.fromJson(Map<String, dynamic> json) {
    return IpDetailModel(
      status: json['status']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      zip: json['zip']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone']?.toString() ?? 'UnKnown',
      isp: json['isp']?.toString() ?? '',
      org: json['org']?.toString() ?? '',
      as: json['as']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
    );
  }
}
