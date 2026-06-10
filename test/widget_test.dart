import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/main.dart';

void main() {
  testWidgets('QuickSlotApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    // Verify that the app loads the LoginPage (or any widget) – the first widget should be a Scaffold or MaterialApp
    expect(find.byType(QuickSlotApp), findsOneWidget);
  });
}

