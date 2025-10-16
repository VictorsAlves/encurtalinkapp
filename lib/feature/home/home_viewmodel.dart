import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/domain/use_case/create_short_link_use_case.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

class HomeViewModel extends ChangeNotifier {
  final _log = Logger('HomeViewModel');

  List<ShortLinkModel> shortLinks = [];
  bool isLoading = false;
  final CreateShortLinkUseCase _shortLinkUseCase;

  HomeViewModel({required CreateShortLinkUseCase shortLinkUseCase})
    : _shortLinkUseCase = shortLinkUseCase;

  Future<Result<void>> createShortLink(String url) async {
    isLoading = true;
    notifyListeners();

    final result = await _shortLinkUseCase.create(url);

    try {
      switch (result) {
        case Ok<ShortLinkModel>():
          _log.fine('Created short Link');
          shortLinks.add(result.value);
          return const Result.ok(null);

        case Error<ShortLinkModel>():
          _log.warning('Create short link error: ${result.error}');
          return Result.error(result.error);
      }
    } finally {
      _updateSucess();
    }
  }

  void _updateSucess() {
    isLoading = false;
    notifyListeners();
  }
}
