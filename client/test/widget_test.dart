import 'package:flutter_test/flutter_test.dart';

import 'package:client/app/app.dart';
import 'package:client/app/dependencies.dart';
import 'package:client/app/dependencies_scope.dart';

void main() {
  testWidgets('Main shell shows home tab title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const DependenciesScope(
        dependencies: Dependencies(),
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reciper'), findsOneWidget);
  });
}
