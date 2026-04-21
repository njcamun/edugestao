import 'package:flutter_test/flutter_test.dart';
import 'package:edugestao/src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App basic render test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
