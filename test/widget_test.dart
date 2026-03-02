import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindhause/app/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MindHauseApp()),
    );
    // Use pump (not pumpAndSettle) — the database stream provider keeps
    // the widget tree rebuilding, so pumpAndSettle will never settle.
    await tester.pump();

    // App shell should render with bottom navigation
    expect(find.text('Tasks'), findsWidgets);
  });
}
