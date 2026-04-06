import 'package:flutter/material.dart';

/// Provides [PageController] and navigation callbacks for onboarding [PageView].
class OnboardingControllerScope extends InheritedWidget {
  const OnboardingControllerScope({
    super.key,
    required this.pageController,
    required this.pageIndex,
    required this.pageCount,
    required this.goBack,
    required this.goNext,
    required super.child,
  });

  final PageController pageController;
  final int pageIndex;
  final int pageCount;
  final VoidCallback goBack;
  final VoidCallback goNext;

  static OnboardingControllerScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<OnboardingControllerScope>();
    assert(scope != null, 'OnboardingControllerScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant OnboardingControllerScope oldWidget) {
    return pageController != oldWidget.pageController ||
        pageIndex != oldWidget.pageIndex ||
        pageCount != oldWidget.pageCount;
  }
}
