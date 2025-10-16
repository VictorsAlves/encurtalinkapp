import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository.dart';
import '../../../util/result.dart';
import '../../services/api/api_client.dart';
import '../models/shorted_link_response.dart';

class ShortLinkRepositoryRemote implements ShortLinkRepository {
  final ApiClient apiClient;

  ShortLinkRepositoryRemote({required this.apiClient});

  @override
  Future<Result<ShortLinkResponse>> createShortLink(String url) async {
    return await apiClient.createShortLink(url);
  }

  @override
  Future<Result<ShortedLinkResponse>> getShortLink(String alias) {
    return apiClient.getShortLink(alias);
  }
}
