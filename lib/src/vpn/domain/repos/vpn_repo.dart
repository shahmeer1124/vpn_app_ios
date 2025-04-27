import 'package:openvpn_flutter_example/core/utils/typedefs.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/ip_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';

abstract class VpnRepo {
  const VpnRepo();
  ResultFuture<IPDetails> getUserLocation();
  ResultFuture<List<Vpn>> getAvailableVpnList();
}
