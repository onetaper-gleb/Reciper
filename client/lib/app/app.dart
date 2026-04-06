import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../domain/bloc/onboarding/onboarding_bloc.dart';
import '../module/onboarding/onboarding_screen.dart';
import 'dependencies_scope.dart';
import 'routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _onOnboardingFinished() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      home: _AppHome(onOnboardingFinished: _onOnboardingFinished),
    );
  }
}

class _AppHome extends StatelessWidget {
  const _AppHome({required this.onOnboardingFinished});

  final VoidCallback onOnboardingFinished;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final done = deps.settingsRepository.onboardingCompleted;
    // For testing purposes
    // final done = false;
    // print('AppHome: done = $done');
    if (!done) {
      return BlocProvider(
        create: (_) => OnboardingBloc(deps.profileRepository),
        child: OnboardingScreen(onFinished: onOnboardingFinished),
      );
    }
    return const MainShell();
  }
}
