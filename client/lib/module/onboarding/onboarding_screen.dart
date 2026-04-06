import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/bloc/profile/profile_bloc.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';
import 'package:client/module/onboarding/widgets/onboarding_progress_bar.dart';
import 'package:client/module/onboarding/widgets/step_activity.dart';
import 'package:client/module/onboarding/widgets/step_age.dart';
import 'package:client/module/onboarding/widgets/step_allergies.dart';
import 'package:client/module/onboarding/widgets/step_body.dart';
import 'package:client/module/onboarding/widgets/step_gender.dart';
import 'package:client/module/onboarding/widgets/step_goal.dart';
import 'package:client/module/onboarding/widgets/step_name.dart';
import 'package:client/module/onboarding/widgets/step_result.dart';
import 'package:client/module/onboarding/widgets/step_welcome.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const int _pageCount = 9;

  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    print('OnboardingScreen: initState');
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_pageIndex <= 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext() {
    if (_pageIndex >= _pageCount - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) =>
          curr is OnboardingEditing &&
          curr.errorMessage != null &&
          (prev is! OnboardingEditing ||
              prev.errorMessage != curr.errorMessage),
      listener: (context, state) {
        final s = state as OnboardingEditing;
        final msg = s.errorMessage;
        if (msg != null && msg.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      },
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (p, c) => c is OnboardingCompleted,
        listener: (context, state) {
          context.read<ProfileBloc>().add(const ProfileLoadRequested());
          widget.onFinished();
        },
        child: SafeArea(
          child: Stack(
          children: [
            OnboardingControllerScope(
              pageController: _pageController,
              pageIndex: _pageIndex,
              pageCount: _pageCount,
              goBack: _goBack,
              goNext: _goNext,
              child: Scaffold(
                appBar: AppBar(
                  leading: _pageIndex > 0
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _goBack,
                        )
                      : null,
                  title: const Text('Настройка'),
                ),
                body: Column(
                  children: [
                    OnboardingProgressBar(
                      currentIndex: _pageIndex,
                      totalSteps: _pageCount,
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) => setState(() => _pageIndex = i),
                        children: const [
                          StepWelcome(),
                          StepName(),
                          StepGender(),
                          StepAge(),
                          StepBody(),
                          StepGoal(),
                          StepActivity(),
                          StepAllergies(),
                          StepResult(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (p, c) =>
                  c is OnboardingSubmitting || p is OnboardingSubmitting,
              builder: (context, state) {
                if (state is OnboardingSubmitting) {
                  return const ColoredBox(
                    color: Color(0x66000000),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
