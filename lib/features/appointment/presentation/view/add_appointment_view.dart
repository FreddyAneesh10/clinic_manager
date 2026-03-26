import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../core/widgets/form_action_button.dart';
import '../../../../core/widgets/responsive.dart';
import '../../../receptionist/presentation/router/receptionist_router.dart';
import '../../appointment_providers.dart';
import '../controller/add_appointment_controller.dart';

class AddAppointmentView extends ConsumerStatefulWidget {
  const AddAppointmentView({super.key});
  @override
  ConsumerState<AddAppointmentView> createState() => _AddAppointmentViewState();
}

class _AddAppointmentViewState extends ConsumerState<AddAppointmentView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appointmentProvider.notifier).loadAppointments());
  }

  Future<void> _selectDate(AddAppointmentController ctrl) async {
    final res = await showDatePicker(
      context: context,
      initialDate: ctrl.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (res != null) ctrl.setDate(res);
  }

  Future<void> _selectTime(AddAppointmentController ctrl) async {
    final res = await showTimePicker(
      context: context,
      initialTime: ctrl.selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (res != null) ctrl.setTime(res);
  }

  Future<void> _save(AddAppointmentController ctrl) async {
    final error = ctrl.validateForm();
    if (error != null) {
      showAppDialog(context: context, title: 'Error', message: error, type: DialogType.error);
      return;
    }
    if (await ctrl.save() && mounted) {
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
    final ctrl = ref.watch(addAppointmentControllerProvider);

    ref.listen(appointmentProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(context: context, title: 'Error', message: next.error!, type: DialogType.error);
        ref.read(appointmentProvider.notifier).clearError();
      }
    });

    if (state.isLoading && ctrl.nameController.text.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: AppCard(
              child: Form(
                key: ctrl.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    LabeledField(
                      label: 'Patient Name',
                      child: CustomTextField(
                        controller: ctrl.nameController,
                        hintText: 'Enter patient full name...',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: ctrl.validateName,
                      ),
                    ),
                    const SizedBox(height: 24),
                    LabeledField(
                      label: 'Phone Number',
                      child: CustomTextField(
                        controller: ctrl.phoneController,
                        hintText: 'Enter mobile number...',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        validator: ctrl.validatePhone,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _DateTimeSelection(
                      ctrl: ctrl,
                      onDate: () => _selectDate(ctrl),
                      onTime: () => _selectTime(ctrl),
                    ),
                    const SizedBox(height: 24),
                    LabeledField(
                      label: 'Visit Reason',
                      child: CustomTextField(
                        controller: ctrl.reasonController,
                        maxLines: 3,
                        hintText: 'Describe the main reason for the visit...',
                        alignLabelWithHint: true,
                        validator: ctrl.validateReason,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FormActionButton(
                      isLoading: state.isLoading,
                      label: 'Save Appointment',
                      onAction: () => _save(ctrl),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateTimeSelection extends StatelessWidget {
  final AddAppointmentController ctrl;
  final VoidCallback onDate, onTime;
  const _DateTimeSelection({required this.ctrl, required this.onDate, required this.onTime});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final dateStr = ctrl.selectedDate == null ? 'Choose Date' : DateFormat('MMM d, yyyy').format(ctrl.selectedDate!);
    final timeStr = ctrl.selectedTime == null ? 'Choose Time' : ctrl.selectedTime!.format(context);

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
              isEmpty: ctrl.selectedDate == null,
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
              isEmpty: ctrl.selectedTime == null,
            ),
          ),
        ),
      ],
    );
  }
}
