import 'package:flutter_test/flutter_test.dart';
import 'package:eventsphere/main.dart';

void main() {
  testWidgets('EventSphere app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const EventSphereApp());
    expect(find.text('EventSphere'), findsOneWidget);
  });
}
