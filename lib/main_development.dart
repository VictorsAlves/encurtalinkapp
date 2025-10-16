import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injections.dart';
import 'main.dart';

void main() {
  Logger.root.level = Level.ALL;
  runApp(MultiProvider(providers: providersLocal, child: const MainApp()));
}
