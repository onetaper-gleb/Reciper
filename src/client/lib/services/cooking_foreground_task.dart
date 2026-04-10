import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Notification action ids (must match [TaskHandler.onNotificationButtonPressed]).
const String cookingForegroundButtonPrev = 'cooking_prev';
const String cookingForegroundButtonNext = 'cooking_next';

@pragma('vm:entry-point')
void cookingForegroundTaskStartCallback() {
  FlutterForegroundTask.setTaskHandler(CookingForegroundTaskHandler());
}

class CookingForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onNotificationButtonPressed(String id) {
    switch (id) {
      case cookingForegroundButtonPrev:
        FlutterForegroundTask.sendDataToMain(<String, String>{'action': 'previous'});
      case cookingForegroundButtonNext:
        FlutterForegroundTask.sendDataToMain(<String, String>{'action': 'next'});
    }
  }
}

class CookingForegroundTaskCoordinator {
  CookingForegroundTaskCoordinator._();

  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'reciper_cooking',
        channelName: 'Режим готовки',
        channelDescription: 'Текущий шаг рецепта и быстрые действия.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
      ),
    );
    _initialized = true;
  }

  static Future<void> requestNotificationPermissionIfNeeded() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    final status = await FlutterForegroundTask.checkNotificationPermission();
    if (status != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  static String _shortStep(String text, {int max = 160}) {
    final t = text.trim();
    if (t.length <= max) return t;
    return '${t.substring(0, max - 1)}…';
  }

  static Future<void> startOrUpdate({
    required String recipeTitle,
    required String stepText,
    required int stepNumber,
    required int totalSteps,
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    await ensureInitialized();
    final body =
        'Шаг $stepNumber из $totalSteps: ${_shortStep(stepText)}';
    const buttons = [
      NotificationButton(id: cookingForegroundButtonPrev, text: 'Назад'),
      NotificationButton(id: cookingForegroundButtonNext, text: 'Далее'),
    ];
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: _shortStep(recipeTitle, max: 40),
        notificationText: body,
        notificationButtons: buttons,
      );
      return;
    }
    if (Platform.isAndroid) {
      await FlutterForegroundTask.startService(
        serviceId: 8912,
        notificationTitle: _shortStep(recipeTitle, max: 40),
        notificationText: body,
        notificationButtons: buttons,
        callback: cookingForegroundTaskStartCallback,
        serviceTypes: const [ForegroundServiceTypes.microphone],
      );
    } else {
      await FlutterForegroundTask.startService(
        serviceId: 8912,
        notificationTitle: _shortStep(recipeTitle, max: 40),
        notificationText: body,
        notificationButtons: buttons,
        callback: cookingForegroundTaskStartCallback,
      );
    }
  }

  static Future<void> stop() async {
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.stopService();
  }
}
