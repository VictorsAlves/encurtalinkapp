import 'package:encurtalinkapp/data/repositories/models/short_link_response.dart';
import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository.dart';
import 'package:encurtalinkapp/domain/models/shortlink_model.dart';
import 'package:encurtalinkapp/util/result.dart';
import 'package:logging/logging.dart';

class CreateShortLinkUseCase {
  final ShortLinkRepository repository;
  final Logger _log = Logger('CreateShortLinkUseCase');

  CreateShortLinkUseCase({required this.repository});

  Future<Result<ShortLinkModel>> create(String url) async {
    if (url.isEmpty) {
      _log.warning('URL is empty');
      return Result.error(Exception('URL cannot be empty'));
    }

    final result = await repository.createShortLink(url);

    switch (result) {
      case Ok<ShortLinkResponse>():
        final response = result.value;
        final model = ShortLinkModel(
          alias: response.alias,
          originalUrl: response.originalUrl,
          shortUrl: response.shortUrl,
        );
        _log.fine('ShortLink created: ${model.shortUrl}');

        return Result.ok(model);

      case Error<ShortLinkResponse>():
        _log.warning('Failed to create ShortLink', result.error);
        return Result.error(result.error);
    }
  }
}
