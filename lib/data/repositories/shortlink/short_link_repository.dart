import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/models/shorted_link_response.dart';
import 'package:encurtalinkapp/util/result.dart';

abstract class ShortLinkRepository {
  Future<Result<ShortLinkResponse>> createShortLink(String url);

  Future<Result<ShortedLinkResponse>> getShortLink(String alias);
}
