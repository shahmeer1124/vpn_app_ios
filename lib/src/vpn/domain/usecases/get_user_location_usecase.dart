import 'package:openvpn_flutter_example/core/usecases/usecases.dart';
import 'package:openvpn_flutter_example/core/utils/typedefs.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/ip_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/repos/vpn_repo.dart';

class GetUserLocationUseCase extends UseCaseWithOutParams<IPDetails> {
  const GetUserLocationUseCase(this._repo);
  final VpnRepo _repo;
  @override
  ResultFuture<IPDetails> call() => _repo.getUserLocation();
}
