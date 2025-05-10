import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';

enum FilterType {
  lowestPing('Lowest Ping'),
  fastestSpeed('Fastest Speed'),
  lowestConnections('Lowest Connections'),
  name('Name');

  final String displayName;
  const FilterType(this.displayName);
}

extension FilterTypeX on FilterType {
  List<Vpn> applyAll(
    List<Vpn> vpns,
    FilterType filterType, [
    String? searchQuery,
  ]) {
    var result = List<Vpn>.from(vpns);

    // Apply search query filtering if provided
    if (searchQuery != null && searchQuery.isNotEmpty && searchQuery != '') {
      if (filterType == FilterType.name) {
        result = result
            .where((vpn) =>
                vpn.hostname
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                vpn.countryLong
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
            .toList();
      }
    }

    switch (filterType) {
      case FilterType.lowestPing:
        if (result.isNotEmpty) {
          result.sort((a, b) {
            // Convert ping to int for comparison, assuming ping is a string representation of a number
            final aPing = int.tryParse(a.ping) ?? 0;
            final bPing = int.tryParse(b.ping) ?? 0;
            return aPing.compareTo(bPing);
          });
        }

      case FilterType.fastestSpeed:
        if (result.isNotEmpty) {
          result.sort((a, b) {
            // Sort by speed in descending order (higher speed first)
            final speedComparison = b.speed.compareTo(a.speed);
            if (speedComparison != 0) return speedComparison;
            // If speeds are equal, sort by hostname
            return a.hostname.toLowerCase().compareTo(b.hostname.toLowerCase());
          });
        }

      case FilterType.lowestConnections:
        if (result.isNotEmpty) {
          result.sort((a, b) {
            // Sort by number of VPN sessions (lower first)
            final sessionComparison =
                a.numVpnSessions.compareTo(b.numVpnSessions);
            if (sessionComparison != 0) return sessionComparison;
            // If sessions are equal, sort by hostname
            return a.hostname.toLowerCase().compareTo(b.hostname.toLowerCase());
          });
        }

      case FilterType.name:
        if (result.isNotEmpty) {
          result.sort(
            (a, b) =>
                a.countryShort.toLowerCase().compareTo(b.countryShort.toLowerCase()),
          );
        }
    }

    return result;
  }
}
