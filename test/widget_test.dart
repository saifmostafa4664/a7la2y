import 'package:a7la2y/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app loads the login screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('مرحباً بك مجدداً'), findsOneWidget);
  });
}
