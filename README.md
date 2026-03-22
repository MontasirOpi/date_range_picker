# date_with_range_picker

A customizable Flutter date range picker dialog widget with flexible styling and callbacks. Supports both **date range** and **single date** selection modes.

## Screenshot

![Date Range Picker Screenshot](https://raw.githubusercontent.com/MontasirOpi/date_range_picker/main/doc/screenshot.png)

## Features

- 📅 Dialog-based date range picker
- 🔁 Single date or date range selection via `isRange` flag
- 🚫 Prevents selecting past dates
- 🎨 Fully customizable `primaryColor`
- ✅ Simple callback with `DateTimeRange` on submit
- 🗓️ Navigate months with prev/next arrows

## Installation

Add the package to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  date_with_range_picker: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Using the convenience function (recommended)

```dart
import 'package:date_with_range_picker/date_with_range_picker.dart';

// Range picker (default)
final result = await showCustomDateRangePicker(
  context,
  primaryColor: Colors.blue,
);

if (result != null) {
  print('From: ${result.start}, To: ${result.end}');
}

// Single date picker
final result = await showCustomDateRangePicker(
  context,
  isRange: false,
  primaryColor: Colors.blue,
);
```

### Using the widget directly

```dart
import 'package:date_with_range_picker/date_with_range_picker.dart';
import 'package:flutter/material.dart';

showDialog<DateTimeRange>(
  context: context,
  builder: (context) => CustomDateRangePicker(
    isRange: true,              // false for single date
    primaryColor: Colors.blue,
    onSubmit: (range) {
      // range.start and range.end
    },
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isRange` | `bool` | `true` | `true` for range, `false` for single date |
| `primaryColor` | `Color` | `Color(0xFF0046D1)` | Accent color for the right panel and highlights |
| `onSubmit` | `Function(DateTimeRange)?` | `null` | Called when user taps SUBMIT |
| `initialMonth` | `DateTime?` | `DateTime.now()` | The month initially displayed |

## Example

See the `example/` folder for a minimal demo app.

## Contributing

See `CONTRIBUTING.md` for guidelines.

## License

This project is licensed under the MIT License — see the `LICENSE` file for details.
