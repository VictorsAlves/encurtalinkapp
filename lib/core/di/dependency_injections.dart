import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository.dart';
import 'package:encurtalinkapp/data/repositories/shortlink/short_link_repository_remote.dart';
import 'package:encurtalinkapp/data/services/api/api_client.dart';
import 'package:encurtalinkapp/domain/use_case/create_short_link_use_case.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> _sharedProviders = [
  Provider(
    lazy: true,
    create: (context) => CreateShortLinkUseCase(repository: context.read()),
  ),
];

/// Configure dependencies for remote data.
List<SingleChildWidget> get providersRemote {
  return [
    Provider(create: (context) => ApiClient()),
    Provider(
      create:
          (context) =>
              ShortLinkRepositoryRemote(apiClient: context.read())
                  as ShortLinkRepository,
    ),

    ..._sharedProviders,
  ];
}

/// Configure dependencies for remote data.
List<SingleChildWidget> get providersLocal {
  return [Provider(create: (context) => ApiClient()), ..._sharedProviders];
}
