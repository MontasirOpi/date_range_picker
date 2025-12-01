import 'package:date_range_picker/date_range_picker.dart';
import 'package:flutter/material.dart';

/// Import your custom date range picker code
/// You can also move this code to a separate file: `custom_date_range_picker.dart`
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Range Picker Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Date Range Picker Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await showDialog<DateTimeRange>(
              context: context,
              builder: (context) => CustomDateRangePicker(
                primaryColor: Colors.blue,
                onSubmit: (range) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Selected: ${range.start.day}/${range.start.month}/${range.start.year} "
                        "- ${range.end.day}/${range.end.month}/${range.end.year}",
                      ),
                    ),
                  );
                },
              ),
            );
            if (result != null) {
              debugPrint("Dialog returned: ${result.start} - ${result.end}");
            }
          },
          child: const Text("Open Date Range Picker"),
        ),
      ),
    );
  }
}
