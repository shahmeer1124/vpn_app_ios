class Vpn {
  Vpn({
    required this.hostname,
    required this.ip,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.openVPNConfigDataBase64,
  });
  const Vpn.empty()
      : hostname = '',
        ip = '',
        ping = '',
        speed = 0,
        countryLong = '',
        countryShort = '',
        numVpnSessions = 0,
        openVPNConfigDataBase64 = '';
  final String hostname;
  final String ip;
  final String ping;
  final int speed;
  final String countryLong;
  final String countryShort;
  final int numVpnSessions;
  final String openVPNConfigDataBase64;
}
