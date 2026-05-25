import 'package:flutter_test/flutter_test.dart';
import 'package:app_bilikbecakap/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BilikBecakapApp());
    expect(find.byType(BilikBecakapApp), findsOneWidget);
  });
}
