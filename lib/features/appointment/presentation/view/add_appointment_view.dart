import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/responsive.dart';
import '../../appointment_providers.dart';
import '../../../receptionist/presentation/router/receptionist_router.dart';

class AddAppointmentView extends ConsumerStatefulWidget {
  const AddAppointmentView({super.key});

  @override
  ConsumerState<AddAppointmentView> createState() => _AddAppointmentViewState();
}

class _AddAppointmentViewState extends ConsumerState<AddAppointmentView> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appointmentProvider.notifier).loadAppointments());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      if (picked.hour < 9 || picked.hour >= 18) {
        if (!context.mounted) return;
        showAppDialog(
          context: context,
          title: 'Invalid Time',
          message: 'Please select a time between 9:00 AM and 6:00 PM',
          type: DialogType.error,
        );
        return;
      }
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDate == null) {
      showAppDialog(
        context: context,
        title: 'Selection Required',
        message: 'Please select a date for the appointment',
        type: DialogType.error,
      );
      return;
    }

    if (_selectedTime == null) {
      showAppDialog(
        context: context,
        title: 'Selection Required',
        message: 'Please select a time for the appointment',
        type: DialogType.error,
      );
      return;
    }

    if (_selectedTime!.hour < 9 || _selectedTime!.hour >= 18) {
      showAppDialog(
        context: context,
        title: 'Invalid Time',
        message: 'Appointment time must be between 9:00 AM and 6:00 PM',
        type: DialogType.error,
      );
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      showAppDialog(
        context: context,
        title: 'Invalid Phone',
        message: 'Please enter a valid 10-digit phone number',
        type: DialogType.error,
      );
      return;
    }
    
    // Format datetime
    final dt = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );
    final timeStr = DateFormat('MMM d, yyyy - h:mm a').format(dt);

    final appointment = AppointmentEntity(
      id: const Uuid().v4(),
      patientId: const Uuid().v4(), // Generate temporary/new patient ID
      patientName: name,
      phone: phone,
      time: timeStr,
      reason: _reasonController.text.trim(),
    );

    final success = await ref.read(appointmentProvider.notifier).addAppointment(appointment);

    if (success && mounted) {
      showAppDialog(
        context: context,
        title: 'Success',
        message: 'Appointment added successfully',
        type: DialogType.success,
        onConfirm: () => context.go(ReceptionistRouter.dashboard),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentProvider);

    ref.listen(appointmentProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(
          context: context,
          title: 'Error',
          message: next.error!,
          type: DialogType.error,
        );
        ref.read(appointmentProvider.notifier).clearError();
      }
    });

    return state.isLoading && _nameController.text.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: AppCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointment Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 24),

                        // Patient Selection
                        // Patient Name
                        const Text('Patient Name',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Enter patient full name...',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 24),

                        // Patient Phone
                        const Text('Phone Number',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'Enter mobile number...',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 24),

                        Flex(
                          direction: Responsive.isMobile(context)
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Selection
                            Expanded(
                              flex: Responsive.isMobile(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Select Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectDate(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                      child: Text(
                                        _selectedDate == null
                                            ? 'Choose Date'
                                            : DateFormat('MMM d, yyyy')
                                                .format(_selectedDate!),
                                        style: TextStyle(
                                          color: _selectedDate == null
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              const SizedBox(width: 16)
                            else
                              const SizedBox(height: 24),

                            // Time Selection
                            Expanded(
                              flex: Responsive.isMobile(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Select Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectTime(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.access_time),
                                      ),
                                      child: Text(
                                        _selectedTime == null
                                            ? 'Choose Time'
                                            : _selectedTime!.format(context),
                                        style: TextStyle(
                                          color: _selectedTime == null
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Reason
                        const Text('Visit Reason',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _reasonController,
                          maxLines: 3,
                          hintText: 'Describe the main reason for the visit...',
                          alignLabelWithHint: true,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 32),

                        // Save
                        Align(
                          alignment: Responsive.isMobile(context)
                              ? Alignment.center
                              : Alignment.centerRight,
                          child: SizedBox(
                            width: Responsive.isMobile(context)
                                ? double.infinity
                                : 200,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _save,
                              child: state.isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Text('Save Appointment'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
