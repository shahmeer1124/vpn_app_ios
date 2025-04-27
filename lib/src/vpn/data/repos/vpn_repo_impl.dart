import 'package:dartz/dartz.dart';
import 'package:openvpn_flutter_example/core/errors/exceptions.dart';
import 'package:openvpn_flutter_example/core/errors/failure.dart';
import 'package:openvpn_flutter_example/core/utils/typedefs.dart';
import 'package:openvpn_flutter_example/src/vpn/data/data_source/vpn_datasource.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/ip_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/vpn_detail_entity.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/repos/vpn_repo.dart';

class VpnRepoImpl implements VpnRepo {
  const VpnRepoImpl(this._vpnDataSource);
  final VpnDataSource _vpnDataSource;
  @override
  ResultFuture<List<Vpn>> getAvailableVpnList() async {
    try {
      final result = await _vpnDataSource.getAvailableVpnList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<IPDetails> getUserLocation() async {
    try {
      final result = await _vpnDataSource.getUserLocation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
