import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/feature/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock/mocks.dart';

class ShortLinkUIModel {
  final String shortUrl;
  final String originalUrl;

  ShortLinkUIModel(this.shortUrl, this.originalUrl);
}

void main() {
  late FakeHomeViewModel viewModel;

  Widget buildTestableWidget() {
    return MaterialApp(home: HomePage(viewModel: viewModel));
  }

  setUp(() {
    viewModel = FakeHomeViewModel();
  });

  testWidgets('Exibe mensagem de vazio quando não há links', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Nenhum link encurtado ainda.'), findsOneWidget);
  });

  testWidgets('Exibe shimmer quando está carregando', (
    WidgetTester tester,
  ) async {
    viewModel.isLoading = true;
    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Exibe lista de links quando shortLinks possui itens', (
    WidgetTester tester,
  ) async {
    viewModel.shortLinks = [
      ShortLinkModel(
        shortUrl: 'https://short.ly/abc',
        originalUrl: 'https://google.com',
        alias: 'abc',
      ),
      ShortLinkModel(
        shortUrl: 'https://short.ly/xyz',
        originalUrl: 'https://flutter.dev',
        alias: 'xyz',
      ),
    ];

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('https://short.ly/abc'), findsOneWidget);
    expect(find.text('https://flutter.dev'), findsOneWidget);
  });

  testWidgets('Exibe snackbar quando tenta encurtar URL vazia', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());

    await tester.tap(find.widgetWithText(FilledButton, 'Encurtar'));
    await tester.pump();

    expect(find.text('Insira uma URL válida'), findsOneWidget);
    expect(viewModel.createCalled, isFalse);
  });

  testWidgets('Chama createShortLink quando URL é válida', (tester) async {
    final viewModel = FakeHomeViewModel();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomePage(viewModel: viewModel),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'https://flutter.dev');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Encurtar'));
    await tester.pumpAndSettle();

    expect(viewModel.createCalled, isTrue);
    expect(viewModel.lastUrlCalled, 'https://flutter.dev');
  });


  testWidgets('Exibe snackbar "Link copiado!" ao clicar no botão de copiar', (
    WidgetTester tester,
  ) async {
    viewModel.shortLinks = [
      ShortLinkModel(
        shortUrl: 'https://short.ly/abc',
        originalUrl: 'https://google.com',
        alias: 'abc',
      ),
    ];

    await tester.pumpWidget(buildTestableWidget());
    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    expect(find.text('Link copiado!'), findsOneWidget);
  });
}
