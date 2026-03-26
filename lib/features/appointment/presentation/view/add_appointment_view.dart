import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/form_action_button.dart';
import '../../../../core/widgets/date_time_selection.dart';
import '../../../receptionist/presentation/router/receptionist_router.dart';
import '../../appointment_providers.dart';
import '../handler/add_appointment_handler.dart';

class AddAppointmentView extends ConsumerStatefulWidget {
  const AddAppointmentView({super.key});
  @override
  ConsumerState<AddAppointmentView> createState() => _AddAppointmentViewState();
}

class _AddAppointmentViewState extends ConsumerState<AddAppointmentView> {
  final _handler = AddAppointmentHandler();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appointmentProvider.notifier).loadAppointments());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final res = await _handler.selectDate(context, _selectedDate);
    if (res != null) setState(() => _selectedDate = res);
  }

  Future<void> _selectTime() async {
    final res = await _handler.selectTime(context, _selectedTime);
    if (res != null) setState(() => _selectedTime = res);
  }

  Future<void> _save() async {
    final error = _handler.validateForm(
      formKey: _formKey,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      phone: _phoneController.text.trim(),
    );

    if (error != null) {
      showAppDialog(context: context, title: 'Error', message: error, type: DialogType.error);
      return;
    }

    final entity = _handler.buildEntity(
      selectedDate: _selectedDate!,
      selectedTime: _selectedTime!,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      reason: _reasonController.text.trim(),
    );

    final success = await ref.read(appointmentProvider.notifier).addAppointment(entity);

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
        showAppDialog(context: context, title: 'Error', message: next.error!, type: DialogType.error);
        ref.read(appointmentProvider.notifier).clearError();
      }
    });

    if (state.isLoading && _nameController.text.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
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
                  Text('Appointment Details', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24),
                  LabeledField(
                    label: 'Patient Name',
                    child: CustomTextField(
                      controller: _nameController,
                      hintText: 'Enter patient full name...',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LabeledField(
                    label: 'Phone Number',
                    child: CustomTextField(
                      controller: _phoneController,
                      hintText: 'Enter mobile number...',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  DateTimeSelection(
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onDate: _selectDate,
                    onTime: _selectTime,
                  ),
                  const SizedBox(height: 24),
                  LabeledField(
                    label: 'Visit Reason',
                    child: CustomTextField(
                      controller: _reasonController,
                      maxLines: 3,
                      hintText: 'Describe the main reason for the visit...',
                      alignLabelWithHint: true,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FormActionButton(
                    isLoading: state.isLoading,
                    label: 'Save Appointment',
                    onAction: _save,
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
