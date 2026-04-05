import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/dependencies_scope.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  const dependencies = Dependencies();

  runApp(
    const DependenciesScope(
      dependencies: dependencies,
      child: MyApp(),
    ),
  );
}
