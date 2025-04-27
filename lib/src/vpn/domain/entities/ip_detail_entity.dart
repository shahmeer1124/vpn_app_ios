class IPDetails {
  IPDetails({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.as,
    required this.query,
  });

  late final String status;
  late final String country;
  late final String countryCode;
  late final String region;
  late final String regionName;
  late final String city;
  late final String zip;
  late final double lat;
  late final double lon;
  late final String timezone;
  late final String isp;
  late final String org;
  late final String as;
  late final String query;
}