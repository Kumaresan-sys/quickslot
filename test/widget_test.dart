import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('QuickSlotApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    expect(find.byType(QuickSlotApp), findsOneWidget);
  });
}
