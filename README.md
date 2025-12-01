# Date Range Picker

A customizable date range picker for Flutter.

## Features

- Select a date range.
- Customizable colors.
- Responsive design.

## Usage

```dart
import 'package:date_range_picker/date_range_picker.dart';

showDialog(
  context: context,
  builder: (context) => CustomDateRangePicker(
    primaryColor: Colors.blue,
    onSubmit: (range) {
      print("Selected range: ${range.start} - ${range.end}");
    },
  ),
);
```
