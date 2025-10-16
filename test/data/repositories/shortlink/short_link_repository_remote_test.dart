import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/models/shorted_link_response.dart';
import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository_remote.dart';
import 'package:encurtalinkapp/data/services/api/api_client.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ShortLinkRepositoryRemote repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ShortLinkRepositoryRemote(apiClient: mockApiClient);
  });

  group('ShortLinkRepositoryRemote', () {
    const url = 'https://google.com';
    const alias = 'abc123';
    final shortLinkResponse = ShortLinkResponse(
      alias: alias,
      originalUrl: url,
      shortUrl: 'https://short.ly/$alias',
    );

    final shortedLinkResponse =
    ShortedLinkResponse(url: 'https://short.ly/$alias');

    test('deve retornar sucesso quando ApiClient retornar Ok (createShortLink)', () async {

      when(() => mockApiClient.createShortLink(url))
          .thenAnswer((_) async => Result.ok(shortLinkResponse));

      final result = await repository.createShortLink(url);

      expect(result, isA<Ok<ShortLinkResponse>>());
      expect((result as Ok).value.shortUrl, equals('https://short.ly/$alias'));
      verify(() => mockApiClient.createShortLink(url)).called(1);
    });

    test('deve retornar erro quando ApiClient retornar Error (createShortLink)', () async {

      final exception = Exception('Erro ao criar link');
      when(() => mockApiClient.createShortLink(url))
          .thenAnswer((_) async => Result.error(exception));

      final result = await repository.createShortLink(url);

      expect(result, isA<Error<ShortLinkResponse>>());
      expect((result as Error).error, equals(exception));
      verify(() => mockApiClient.createShortLink(url)).called(1);
    });

    test('deve retornar sucesso quando ApiClient retornar Ok (getShortLink)', () async {

      when(() => mockApiClient.getShortLink(alias))
          .thenAnswer((_) async => Result.ok(shortedLinkResponse));

      final result = await repository.getShortLink(alias);

      expect(result, isA<Ok<ShortedLinkResponse>>());
      expect((result as Ok).value.url, equals('https://short.ly/$alias'));
      verify(() => mockApiClient.getShortLink(alias)).called(1);
    });

    test('deve retornar erro quando ApiClient retornar Error (getShortLink)', () async {

      final exception = Exception('Erro ao buscar link');
      when(() => mockApiClient.getShortLink(alias))
          .thenAnswer((_) async => Result.error(exception));

      final result = await repository.getShortLink(alias);

      expect(result, isA<Error<ShortedLinkResponse>>());
      expect((result as Error).error, equals(exception));
      verify(() => mockApiClient.getShortLink(alias)).called(1);
    });
  });
}
