import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/form_action_button.dart';
import '../../../../core/widgets/patient_header.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/medication_input.dart';
import '../../../../core/widgets/queued_section.dart';
import '../../doctor_providers.dart';
import '../router/doctor_router.dart';
import '../handler/add_prescription_handler.dart';

class AddPrescriptionView extends ConsumerStatefulWidget {
  const AddPrescriptionView({super.key});
  @override
  ConsumerState<AddPrescriptionView> createState() => _AddPrescriptionViewState();
}

class _AddPrescriptionViewState extends ConsumerState<AddPrescriptionView> {
  final _handler = AddPrescriptionHandler();
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _medNameController = TextEditingController();
  final _customDosageController = TextEditingController();
  final _notesController = TextEditingController();

  final List<QueuedMedicine> _queuedMedicines = [];
  String _selectedDosage = '250mg';
  String _selectedFrequency = '1x Daily';

  @override
  void dispose() {
    for (var c in [_diagnosisController, _medNameController, _customDosageController, _notesController]) {
      c.dispose();
    }
    super.dispose();
  }

  void _addMedicine() {
    final med = _handler.buildQueuedMedicine(
      name: _medNameController.text,
      selectedDosage: _selectedDosage,
      customDosage: _customDosageController.text,
      frequency: _selectedFrequency,
    );

    if (med == null) {
      showAppDialog(context: context, title: 'Input Required', message: 'Please enter valid medication details', type: DialogType.error);
      return;
    }

    setState(() {
      _queuedMedicines.add(med);
      _medNameController.clear();
      _customDosageController.clear();
      _selectedDosage = '250mg';
      _selectedFrequency = '1x Daily';
    });
  }

  Future<void> _save() async {
    final error = _handler.validatePrescription(diagnosis: _diagnosisController.text, queuedMedicines: _queuedMedicines);
    if (error != null) {
      showAppDialog(context: context, title: 'Input Required', message: error, type: DialogType.error);
      return;
    }

    final state = ref.read(doctorProvider);
    if (state.selectedAppointment == null) return;

    final entity = _handler.buildPrescriptionEntity(
      appointmentId: state.selectedAppointment!.id,
      diagnosis: _diagnosisController.text,
      queuedMedicines: _queuedMedicines,
      notes: _notesController.text,
    );

    if (await ref.read(doctorProvider.notifier).addPrescription(entity) && mounted) {
      showAppDialog(context: context, title: 'Success', message: 'Prescription added successfully', type: DialogType.success, onConfirm: () => context.go(DoctorRouter.dashboard));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorProvider);
    final patient = state.selectedPatient;
    final appointment = state.selectedAppointment;

    if (patient == null || appointment == null) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('No patient selected'),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => context.go(DoctorRouter.dashboard), child: const Text('Back to Queue')),
      ]));
    }

    ref.listen(doctorProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(context: context, title: 'Error', message: next.error!, type: DialogType.error);
        ref.read(doctorProvider.notifier).clearError();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(alignment: Alignment.topCenter, child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: AppCard(child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PatientHeader(name: patient.name, phone: patient.phone, reason: appointment.reason),
          const Divider(height: 48),
          const SectionHeader(icon: Icons.description_outlined, title: 'PRESCRIPTION DETAILS'),
          const SizedBox(height: 24),
          LabeledField(label: 'DIAGNOSIS', child: CustomTextField(controller: _diagnosisController, hintText: 'Enter patient diagnosis...', validator: (v) => v?.isEmpty ?? true ? 'Required' : null)),
          const SizedBox(height: 24),
          MedicationInput(
            controller: _medNameController,
            customDosageController: _customDosageController,
            selectedDosage: _selectedDosage,
            selectedFrequency: _selectedFrequency,
            onDosageChanged: (v) => setState(() => _selectedDosage = v),
            onFrequencyChanged: (v) => setState(() => _selectedFrequency = v),
            onAdd: _addMedicine,
          ),
          const SizedBox(height: 32),
          if (_queuedMedicines.isNotEmpty) 
            QueuedSection(
              items: _queuedMedicines.map((m) => QueuedItemData(title: m.name, subtitle: '${m.dosage} • ${m.frequency}')).toList(), 
              onRemove: (i) => setState(() => _queuedMedicines.removeAt(i)),
            ),
          const SizedBox(height: 32),
          LabeledField(label: 'ADDITIONAL NOTES', child: CustomTextField(controller: _notesController, maxLines: 2, hintText: 'Dose and timing instructions...')),
          const SizedBox(height: 32),
          FormActionButton(isLoading: state.isLoading, label: 'Save & Complete Visit', onAction: _save),
        ]))),
      )),
    );
  }
}
