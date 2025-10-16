import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository.dart';
import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/domain/use_case/create_short_link_use_case.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShortLinkRepository extends Mock implements ShortLinkRepository {}

void main() {
  late MockShortLinkRepository mockRepository;
  late CreateShortLinkUseCase useCase;

  setUp(() {
    mockRepository = MockShortLinkRepository();
    useCase = CreateShortLinkUseCase(repository: mockRepository);
  });

  group('CreateShortLinkUseCase', () {
    const validUrl = 'https://google.com';
    const alias = 'abc123';
    const shortUrl = 'https://short.ly/abc123';

    final response = ShortLinkResponse(
      alias: alias,
      originalUrl: validUrl,
      shortUrl: shortUrl,
    );

    test('deve retornar erro se URL estiver vazia', () async {
      final result = await useCase.create('');

      expect(result, isA<Error<ShortLinkModel>>());
      expect(
        (result as Error).error.toString(),
        contains('URL cannot be empty'),
      );
      verifyNever(() => mockRepository.createShortLink(any()));
    });

    test('deve retornar sucesso quando o repositório retornar Ok', () async {
      when(
        () => mockRepository.createShortLink(validUrl),
      ).thenAnswer((_) async => Result.ok(response));

      final result = await useCase.create(validUrl);

      expect(result, isA<Ok<ShortLinkModel>>());
      final model = (result as Ok).value;
      expect(model.alias, alias);
      expect(model.originalUrl, validUrl);
      expect(model.shortUrl, shortUrl);

      verify(() => mockRepository.createShortLink(validUrl)).called(1);
    });

    test('deve retornar erro quando o repositório retornar Error', () async {
      final exception = Exception('Falha ao criar link');
      when(
        () => mockRepository.createShortLink(validUrl),
      ).thenAnswer((_) async => Result.error(exception));

      final result = await useCase.create(validUrl);

      expect(result, isA<Error<ShortLinkModel>>());
      expect((result as Error).error, equals(exception));

      verify(() => mockRepository.createShortLink(validUrl)).called(1);
    });
  });
}
