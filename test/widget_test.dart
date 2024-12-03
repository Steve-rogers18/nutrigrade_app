import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscore_app/main.dart';

void main() {
  testWidgets('Verify home page loads with default text and scan button',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(NutriScoreApp());

    // Verify the initial text is displayed.
    expect(find.text('Scan a product to get its Nutri-Grade!'), findsOneWidget);

    // Verify the scan button is present using a label.
    expect(find.widgetWithText(ElevatedButton, "Scan Barcode"), findsOneWidget);

    // Verify the app bar title.
    expect(find.text('NutriScore App'), findsOneWidget);
  });
}
