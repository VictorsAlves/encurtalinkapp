import 'package:flutter/material.dart';
import 'core/routing/router.dart';
import 'core/themes/colors/theme.dart';
import 'main_prod.dart' as production;

void main() {
  production.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router(),
    );
  }
}

