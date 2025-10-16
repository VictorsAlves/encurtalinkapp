import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/domain/use_case/create_short_link_use_case.dart';
import 'package:encurtalinkapp/feature/home/home_viewmodel.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateShortLinkUseCase extends Mock
    implements CreateShortLinkUseCase {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class FakeStreamTransformer extends Fake implements Stream<List<int>> {}

class UriFake extends Fake implements Uri {}

class StreamTransformerFake extends Fake
    implements StreamTransformer<Uint8List, String> {}

class FakeHomeViewModel extends ChangeNotifier implements HomeViewModel {
  @override
  bool isLoading = false;

  bool createCalled = false;
  String? lastUrlCalled;

  List<ShortLinkModel> _shortLinks = [];

  @override
  List<ShortLinkModel> get shortLinks => _shortLinks;

  @override
  set shortLinks(List<ShortLinkModel> value) {
    _shortLinks = value;
    notifyListeners();
  }

  @override
  Future<Result<void>> createShortLink(String url) async {
    createCalled = true;
    lastUrlCalled = url;
    return Result.ok(null);
  }
}
