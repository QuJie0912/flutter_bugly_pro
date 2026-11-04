import 'package:flutter_bugly_pro_example/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders plugin example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('putException'), findsOneWidget);
  });
}
