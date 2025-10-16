import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/models/shorted_link_response.dart';
import 'package:encurtalinkapp/data/services/api/api_client.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// -------------------
// Fakes e Mocks
// -------------------

class UriFake extends Fake implements Uri {}
class StreamTransformerFake extends Fake
    implements StreamTransformer<List<int>, List<int>> {}

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

// -------------------
// Testes
// -------------------

void main() {
  late MockHttpClient mockClient;
  late ApiClient apiClient;

  setUpAll(() {
    // Fakes para parâmetros que usam any()
    registerFallbackValue(UriFake());
    registerFallbackValue(StreamTransformerFake());
  });

  setUp(() {
    mockClient = MockHttpClient();
    apiClient = ApiClient(clientFactory: () => mockClient);
  });

  // -------------------
  // Helpers de Mock
  // -------------------

  void mockPost({required int statusCode, required String responseBody}) {
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    when(() => mockClient.postUrl(any())).thenAnswer((_) async => request);
    when(() => request.headers).thenReturn(headers);
    when(() => request.write(any())).thenReturn(null);
    when(() => request.close()).thenAnswer((_) async => response);

    when(() => response.statusCode).thenReturn(statusCode);

    // Retorna Stream<List<int>> (bytes), utf8.decoder vai converter para String
    when(() => response.transform(any())).thenAnswer(
          (_) => Stream<List<int>>.value(utf8.encode(responseBody)),
    );
  }

  void mockGet({required int statusCode, required String responseBody}) {
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();

    when(() => mockClient.getUrl(any())).thenAnswer((_) async => request);
    when(() => request.close()).thenAnswer((_) async => response);

    when(() => response.statusCode).thenReturn(statusCode);

    // Retorna Stream<List<int>> (bytes)
    when(() => response.transform(any())).thenAnswer(
          (_) => Stream<List<int>>.value(utf8.encode(responseBody)),
    );
  }

  // -------------------
  // Testes
  // -------------------

  group('ApiClient', () {
    const testUrl = 'https://google.com';
    const alias = 'abc123';

    test('createShortLink retorna Ok quando statusCode 200', () async {
      final jsonResponse =
          '{"alias":"$alias","originalUrl":"$testUrl","shortUrl":"https://short.ly/$alias"}';

      mockPost(statusCode: 200, responseBody: jsonResponse);

      final result = await apiClient.createShortLink(testUrl);

      expect(result, isA<Ok<ShortLinkResponse>>());
      final model = (result as Ok).value;
      expect(model.alias, alias);
      expect(model.originalUrl, testUrl);
      expect(model.shortUrl, 'https://short.ly/$alias');
    });

    test('createShortLink retorna Error quando statusCode != 200', () async {
      mockPost(statusCode: 500, responseBody: '');

      final result = await apiClient.createShortLink(testUrl);

      expect(result, isA<Error<ShortLinkResponse>>());
      expect((result as Error).error, isA<HttpException>());
    });

    test('getShortLink retorna Ok quando statusCode 200', () async {
      final jsonResponse = '{"url":"https://short.ly/$alias"}';
      mockGet(statusCode: 200, responseBody: jsonResponse);

      final result = await apiClient.getShortLink(alias);

      expect(result, isA<Ok<ShortedLinkResponse>>());
      final model = (result as Ok).value;
      expect(model.url, 'https://short.ly/$alias');
    });

    test('getShortLink retorna Error 404 quando não encontrado', () async {
      mockGet(statusCode: 404, responseBody: '');

      final result = await apiClient.getShortLink(alias);

      expect(result, isA<Error<ShortedLinkResponse>>());
      expect((result as Error).error, isA<HttpException>());
    });

    test('getShortLink retorna Error quando statusCode != 200/404', () async {
      mockGet(statusCode: 500, responseBody: '');

      final result = await apiClient.getShortLink(alias);

      expect(result, isA<Error<ShortedLinkResponse>>());
      expect((result as Error).error, isA<HttpException>());
    });
  });
}
