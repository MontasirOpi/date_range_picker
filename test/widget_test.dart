import 'package:date_with_range_picker/date_with_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomDateRangePicker builds and shows submit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CustomDateRangePicker(
                    onSubmit: (range) {},
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('open'), findsOneWidget);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Submit button label
    expect(find.text('SUBMIT'), findsOneWidget);
  });
}
