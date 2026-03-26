import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../appointment_providers.dart';

final addAppointmentControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  return AddAppointmentController(ref);
});

class AddAppointmentController extends ChangeNotifier {
  final Ref _ref;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final reasonController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  AddAppointmentController(this._ref);

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  String? validateName(String? value) => value?.isEmpty ?? true ? 'Required' : null;
  String? validatePhone(String? value) => value?.isEmpty ?? true ? 'Required' : null;
  String? validateReason(String? value) => value?.isEmpty ?? true ? 'Required' : null;

  String? validateForm() {
    if (!formKey.currentState!.validate()) return 'Please fill all required fields';
    if (_selectedDate == null) return 'Please select a date';
    if (_selectedTime == null) return 'Please select a time';
    
    final phone = phoneController.text.trim();
    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Please enter a valid 10-digit phone number';
    }

    if (_selectedTime!.hour < 9 || _selectedTime!.hour >= 18) {
      return 'Appointment time must be between 9:00 AM and 6:00 PM';
    }

    return null;
  }

  AppointmentEntity buildEntity() {
    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    final timeStr = DateFormat('MMM d, yyyy - h:mm a').format(dt);

    return AppointmentEntity(
      id: const Uuid().v4(),
      patientId: const Uuid().v4(),
      patientName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      time: timeStr,
      reason: reasonController.text.trim(),
    );
  }

  Future<bool> save() async {
    final entity = buildEntity();
    return await _ref.read(appointmentProvider.notifier).addAppointment(entity);
  }
}
