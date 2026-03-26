import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'responsive.dart';
import 'labeled_field.dart';
import 'picker_field.dart';

class DateTimeSelection extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onDate;
  final VoidCallback onTime;

  const DateTimeSelection({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDate,
    required this.onTime,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final dateStr = selectedDate == null ? 'Choose Date' : DateFormat('MMM d, yyyy').format(selectedDate!);
    final timeStr = selectedTime == null ? 'Choose Time' : selectedTime!.format(context);

    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      children: [
        Expanded(
          flex: isMobile ? 0 : 1,
          child: LabeledField(
            label: 'Select Date',
            child: PickerField(
              onTap: onDate,
              icon: Icons.calendar_today,
              value: dateStr,
              isEmpty: selectedDate == null,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 0 : 16, height: isMobile ? 24 : 0),
        Expanded(
          flex: isMobile ? 0 : 1,
          child: LabeledField(
            label: 'Select Time',
            child: PickerField(
              onTap: onTime,
              icon: Icons.access_time,
              value: timeStr,
              isEmpty: selectedTime == null,
            ),
          ),
        ),
      ],
    );
  }
}
