# date_with_range_picker

A customizable Flutter date range picker dialog widget with flexible styling and callbacks. Use this package to quickly add a dialog-based date range selector to your Flutter apps.

## Features
- Dialog-based date range picker
- Start and end date selection
- Prevents selecting past dates
- Simple callback with `DateTimeRange` on submit

## Installation
Add the package to your `pubspec.yaml` dependencies. When published to pub.dev use the version string; during local development you can use a path or git dependency.

```yaml
dependencies:
  date_with_range_picker: ^1.0.8
```

Then run:

```bash
flutter pub get
```

## Usage
Wrap the picker in a `showDialog` call and handle the `onSubmit` callback:

```dart
import 'package:date_with_range_picker/date_with_range_picker.dart';
import 'package:flutter/material.dart';

showDialog<DateTimeRange>(
  context: context,
  builder: (context) => CustomDateRangePicker(
    primaryColor: Colors.blue,
    onSubmit: (range) {
      // Use range.start and range.end
    },
  ),
);
```

## Example
See the `example/` folder for a minimal demo app that shows how to use the picker.

## Screenshots
Add screenshots here (optional).

## Contributing
See `CONTRIBUTING.md` for guidelines.

## License
This project is licensed under the MIT License - see the `LICENSE` file for details.
