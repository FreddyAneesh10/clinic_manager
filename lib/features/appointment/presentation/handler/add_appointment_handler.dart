import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/appointment_entity.dart';

class AddAppointmentHandler {
  Future<DateTime?> selectDate(BuildContext context, DateTime? initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  Future<TimeOfDay?> selectTime(BuildContext context, TimeOfDay? initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
  }

  String? validateForm({
    required GlobalKey<FormState> formKey,
    required DateTime? selectedDate,
    required TimeOfDay? selectedTime,
    required String phone,
  }) {
    if (!formKey.currentState!.validate()) return 'Please fill all required fields';
    if (selectedDate == null) return 'Please select a date';
    if (selectedTime == null) return 'Please select a time';

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Please enter a valid 10-digit phone number';
    }

    if (selectedTime.hour < 9 || selectedTime.hour >= 18) {
      return 'Appointment time must be between 9:00 AM and 6:00 PM';
    }
    return null;
  }

  AppointmentEntity buildEntity({
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required String name,
    required String phone,
    required String reason,
  }) {
    final dt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return AppointmentEntity(
      id: const Uuid().v4(),
      patientId: const Uuid().v4(),
      patientName: name,
      phone: phone,
      time: DateFormat('MMM d, yyyy - h:mm a').format(dt),
      reason: reason,
    );
  }
}
