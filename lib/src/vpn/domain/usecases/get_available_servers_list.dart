import 'package:openvpn_flutter_example/core/usecases/usecases.dart';
import 'package:openvpn_flutter_example/core/utils/typedefs.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/repos/vpn_repo.dart';

class GetAvailableServerListUseCase extends UseCaseWithOutParams<List<Vpn>> {
  GetAvailableServerListUseCase(this._repo);
  final VpnRepo _repo;
  @override
  ResultFuture<List<Vpn>> call() =>_repo.getAvailableVpnList();
}
