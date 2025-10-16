import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/models/shorted_link_response.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'dart:convert';
import 'dart:io';

class ApiClient {
  ApiClient({String? baseUrl, HttpClient Function()? clientFactory})
    : _baseUrl = baseUrl ?? 'https://url-shortener-server.onrender.com/api',
      _clientFactory = clientFactory ?? HttpClient.new;

  final String _baseUrl;
  final HttpClient Function() _clientFactory;

  Future<Result<ShortLinkResponse>> createShortLink(String url) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/alias');
      final request =
          await client.postUrl(uri)
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({'url': url}));

      final response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(stringData);
        final shortLink = ShortLinkResponse.fromJson(jsonData);
        return Result.ok(shortLink);
      } else {
        return Result.error(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  /// GET /api/alias/:id → Busca short link pelo alias
  Future<Result<ShortedLinkResponse>> getShortLink(String alias) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/alias/$alias');
      final request = await client.getUrl(uri);
      final response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(stringData);
        final shortLink = ShortedLinkResponse.fromJson(jsonData);
        return Result.ok(shortLink);
      } else if (response.statusCode == 404) {
        return const Result.error(HttpException("Short link not found"));
      } else {
        return Result.error(
          HttpException('Invalid response: ${response.statusCode}'),
        );
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}
