import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/config/app_config.dart';
import 'package:quickslot/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('QuickSlotApp builds without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const QuickSlotApp(
        config: AppConfig(
          apiBaseUrl: 'http://localhost:5001',
          socketUrl: 'ws://localhost:5001',
        ),
        connectSocket: false,
      ),
    );
    expect(find.byType(QuickSlotApp), findsOneWidget);
  });
}
