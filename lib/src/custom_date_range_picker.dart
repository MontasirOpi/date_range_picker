import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final Color primaryColor;
  final Function(DateTimeRange)? onSubmit;
  final DateTime? initialMonth;

  const CustomDateRangePicker({
    super.key,
    this.primaryColor = Colors.blue,
    this.onSubmit,
    this.initialMonth,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? start;
  DateTime? end;
  late DateTime _focusedMonth;
  final Color rangeHighlightColor = Colors.blue.shade100;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.initialMonth ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 650,
        height: 370,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: _RangeCalendar(
                initialDay: _focusedMonth,
                start: start,
                end: end,
                rangeHighlightColor: rangeHighlightColor,
                onDateChanged: _handleDateChanged,
                onMonthChanged: (newMonth) {
                  setState(() {
                    _focusedMonth = newMonth;
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Container(
                height: 370,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dateInput("From", start, widget.primaryColor),
                    const SizedBox(height: 10),
                    _dateInput("To", end, widget.primaryColor),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (start != null && end != null) {
                          if (widget.onSubmit != null) {
                            widget.onSubmit!(
                              DateTimeRange(start: start!, end: end!),
                            );
                          }
                          Navigator.pop(context);
                        } else if (start != null && end == null) {
                          if (widget.onSubmit != null) {
                            widget.onSubmit!(
                              DateTimeRange(start: start!, end: start!),
                            );
                          }
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select at least a start date.",
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 125,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                            color: widget.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDateChanged(DateTime value) {
    setState(() {
      final selectedDate = DateUtils.dateOnly(value);
      final today = DateUtils.dateOnly(DateTime.now());
      if (selectedDate.isBefore(today)) return;

      if (start == null || end != null) {
        start = selectedDate;
        end = null;
      } else {
        if (selectedDate.isAfter(start!)) {
          end = selectedDate;
        } else if (selectedDate.isBefore(start!)) {
          start = selectedDate;
          end = null;
        } else {
          if (start != null && end == null) {
            end = selectedDate;
          } else {
            start = null;
            end = null;
          }
        }
      }
    });
  }

  Widget _dateInput(String label, DateTime? date, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(minWidth: 130),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            date != null
                ? "${date.day} ${_month(date.month)} ${date.year}"
                : "--",
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }
}

class _RangeCalendar extends StatelessWidget {
  final DateTime initialDay;
  final DateTime? start;
  final DateTime? end;
  final Color rangeHighlightColor;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onMonthChanged;

  const _RangeCalendar({
    required this.initialDay,
    required this.start,
    required this.end,
    required this.rangeHighlightColor,
    required this.onDateChanged,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final currentMonth = DateUtils.dateOnly(initialDay);
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final leadingSpaces = (firstDayOfWeek % 7 == 0) ? 6 : firstDayOfWeek - 1;
    final totalCells = 7 + leadingSpaces + daysInMonth;

    return Column(
      children: [
        _buildMonthHeader(currentMonth),
        _buildDaysOfWeek(),
        SizedBox(
          height: 200,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
            ),
            itemCount: totalCells - 7,
            itemBuilder: (context, index) {
              if (index < leadingSpaces) return const SizedBox.shrink();

              final dayOfMonth = index - leadingSpaces + 1;
              final date = DateTime(
                currentMonth.year,
                currentMonth.month,
                dayOfMonth,
              );
              final isPast = date.isBefore(today);

              bool isSelectedStart =
                  start != null && DateUtils.isSameDay(date, start);
              bool isSelectedEnd =
                  end != null && DateUtils.isSameDay(date, end);
              bool isIntermediate =
                  start != null &&
                  end != null &&
                  date.isAfter(start!) &&
                  date.isBefore(end!);
              bool isSelectedDay = isSelectedStart || isSelectedEnd;
              bool isInRange = isSelectedDay || isIntermediate;

              Color backgroundColor = isInRange
                  ? rangeHighlightColor
                  : Colors.transparent;
              Color textColor = isPast
                  ? Colors.grey
                  : (isSelectedDay ? Colors.white : Colors.black87);
              BorderRadius borderRadius = BorderRadius.zero;

              if (isSelectedDay) {
                if (isSelectedStart && isSelectedEnd) {
                  borderRadius = BorderRadius.circular(8);
                } else if (isSelectedStart) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  );
                } else if (isSelectedEnd) {
                  borderRadius = const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  );
                }
                textColor = Colors.black;
              }

              return GestureDetector(
                onTap: isPast ? null : () => onDateChanged(date),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Text(
                      dayOfMonth.toString(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthHeader(DateTime month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black54),
            onPressed: () =>
                onMonthChanged(DateUtils.addMonthsToMonthDate(month, -1)),
          ),
          Text(
            "${_month(month.month)} ${month.year}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.black54),
            onPressed: () =>
                onMonthChanged(DateUtils.addMonthsToMonthDate(month, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _month(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m - 1];
  }
}
