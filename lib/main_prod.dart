import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injections.dart';
import 'main.dart';

/// production config entry point.
/// Launch with `flutter run --target lib/main_staging.dart`.
/// Uses remote data from a server.
void main() {
  Logger.root.level = Level.ALL;

  runApp(MultiProvider(providers: providersRemote, child: const MainApp()));
}