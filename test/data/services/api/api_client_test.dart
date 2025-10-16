import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/models/shorted_link_response.dart';
import 'package:encurtalinkapp/data/services/api/api_client.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/mocks.dart';

void main() {
  late MockHttpClient mockClient;
  late ApiClient apiClient;

  setUpAll(() {
    registerFallbackValue(UriFake());
    registerFallbackValue(StreamTransformerFake());
  });

  setUp(() {
    mockClient = MockHttpClient();
    apiClient = ApiClient(clientFactory: () => mockClient);
  });

  void mockPost({required int statusCode, required String responseBody}) {
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    when(() => mockClient.postUrl(any())).thenAnswer((_) async => request);
    when(() => request.headers).thenReturn(headers);
    when(() => request.write(any())).thenReturn(null);
    when(() => request.close()).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(statusCode);

    when(
      () => response.transform(any<StreamTransformer<Uint8List, String>>()),
    ).thenAnswer((_) => Stream.value(responseBody));
  }

  void mockGet({required int statusCode, required String responseBody}) {
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();

    when(() => mockClient.getUrl(any())).thenAnswer((_) async => request);
    when(() => request.close()).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(statusCode);

    when(
      () => response.transform(any<StreamTransformer<Uint8List, String>>()),
    ).thenAnswer((_) => Stream.value(responseBody));
  }

  group('ApiClient', () {
    const testUrl = 'https://google.com';
    const alias = 'abc123';

    test('createShortLink retorna Ok quando statusCode 200', () async {
      final jsonResponse = jsonEncode({
        'alias': alias,
        '_links': {'self': testUrl, 'short': 'https://short.ly/$alias'},
      });

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

    test(
      'createShortLink retorna Error quando uma exceção de rede ocorre',
      () async {
        when(
          () => mockClient.postUrl(any()),
        ).thenThrow(const SocketException('Falha de conexão'));

        final result = await apiClient.createShortLink(testUrl);

        expect(result, isA<Error<ShortLinkResponse>>());
        expect((result as Error).error, isA<SocketException>());
      },
    );

    test('getShortLink retorna Ok quando statusCode 200', () async {
      final jsonResponse = jsonEncode({'url': 'https://short.ly/$alias'});
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

    test(
      'getShortLink retorna Error quando uma exceção de rede ocorre',
      () async {
        when(
          () => mockClient.getUrl(any()),
        ).thenThrow(const SocketException('Falha de conexão'));

        final result = await apiClient.getShortLink(alias);

        expect(result, isA<Error<ShortedLinkResponse>>());
        expect((result as Error).error, isA<SocketException>());
      },
    );
  });
}
