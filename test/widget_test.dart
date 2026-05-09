import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('ProviderScope render test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Text('EDUGESTAO'),
          ),
        ),
      ),
    );

    expect(find.text('EDUGESTAO'), findsOneWidget);
  });
}
