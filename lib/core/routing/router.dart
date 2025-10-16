import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../feature/home/home_page.dart';
import '../../feature/home/home_viewmodel.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(shortLinkUseCase: context.read());
        return HomePage(viewModel: viewModel);
      },
      routes: [],
    ),
  ],
);
