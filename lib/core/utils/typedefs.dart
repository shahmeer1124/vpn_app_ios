import 'package:dartz/dartz.dart';
import 'package:openvpn_flutter_example/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;

class UrlSavePlace {
  static const serverUrl = 'http://www.vpngate.net/api/iphone/';
  static const apiIpUrl = 'http://ip-api.com/json/';
}
