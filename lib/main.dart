import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initInjector();

  runApp(const App());
}
