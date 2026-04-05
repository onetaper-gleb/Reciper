import 'package:flutter/widgets.dart';

import 'dependencies.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DependenciesScope>();
    assert(scope != null, 'DependenciesScope not found in context');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(covariant DependenciesScope oldWidget) {
    return !identical(dependencies, oldWidget.dependencies);
  }
}
