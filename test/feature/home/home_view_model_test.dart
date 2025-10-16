import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/domain/use_case/create_short_link_use_case.dart';
import 'package:encurtalinkapp/feature/home/home_viewmodel.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateShortLinkUseCase extends Mock implements CreateShortLinkUseCase {}

void main() {
  late MockCreateShortLinkUseCase mockUseCase;
  late HomeViewModel viewModel;

  setUp(() {
    mockUseCase = MockCreateShortLinkUseCase();
    viewModel = HomeViewModel(shortLinkUseCase: mockUseCase);
  });

  test('deve adicionar short link com sucesso e notificar listeners', () async {
    // Arrange
    final model = ShortLinkModel(
      alias: 'abc123',
      originalUrl: 'https://google.com',
      shortUrl: 'https://short.ly/abc123',
    );

    when(() => mockUseCase.create(any()))
        .thenAnswer((_) async => Result.ok(model));

    bool notified = false;
    viewModel.addListener(() => notified = true);

    // Act
    final result = await viewModel.createShortLink('https://google.com');

    // Assert
    expect(result, isA<Ok<void>>());
    expect(viewModel.shortLinks.length, 1);
    expect(viewModel.shortLinks.first.shortUrl, equals(model.shortUrl));
    expect(notified, isTrue);
    expect(viewModel.isLoading, isFalse);
    verify(() => mockUseCase.create('https://google.com')).called(1);
  });

  test('deve retornar erro ao criar short link e notificar listeners', () async {
    // Arrange
    const errorMessage = 'Erro ao encurtar link';
    when(() => mockUseCase.create(any()))
        .thenAnswer((_) async => Result.error(Exception(errorMessage)));

    bool notified = false;
    viewModel.addListener(() => notified = true);

    // Act
    final result = await viewModel.createShortLink('https://google.com');

    // Assert
    expect(result, isA<Error<void>>());
    expect(viewModel.shortLinks, isEmpty);
    expect(notified, isTrue);
    expect(viewModel.isLoading, isFalse); // deve ser false mesmo em erro
  });
}
