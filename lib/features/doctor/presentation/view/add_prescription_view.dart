import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/prescription_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../doctor_providers.dart';
import '../router/doctor_router.dart';

class AddPrescriptionView extends ConsumerStatefulWidget {
  const AddPrescriptionView({super.key});

  @override
  ConsumerState<AddPrescriptionView> createState() => _AddPrescriptionViewState();
}

class _QueuedMedicine {
  final String name;
  final String dosage;
  final String frequency;

  _QueuedMedicine({required this.name, required this.dosage, required this.frequency});
}

class _AddPrescriptionViewState extends ConsumerState<AddPrescriptionView> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _medNameController = TextEditingController();
  final _customDosageController = TextEditingController();
  final _notesController = TextEditingController();

  final List<_QueuedMedicine> _queuedMedicines = [];
  String _selectedDosage = '250mg';
  String _selectedFrequency = '1x Daily';

  @override
  void dispose() {
    _diagnosisController.dispose();
    _medNameController.dispose();
    _customDosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addMedicine() {
    final medName = _medNameController.text.trim();
    if (medName.isEmpty) {
      showAppDialog(
        context: context,
        title: 'Input Required',
        message: 'Please enter medication name',
        type: DialogType.error,
      );
      return;
    }

    final dosage = _selectedDosage == 'Custom' ? _customDosageController.text.trim() : _selectedDosage;
    if (dosage.isEmpty) {
      showAppDialog(
        context: context,
        title: 'Input Required',
        message: 'Please enter dosage',
        type: DialogType.error,
      );
      return;
    }

    setState(() {
      _queuedMedicines.add(_QueuedMedicine(
        name: medName,
        dosage: dosage,
        frequency: _selectedFrequency,
      ));
      _medNameController.clear();
      _customDosageController.clear();
      _selectedDosage = '250mg';
      _selectedFrequency = '1x Daily';
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      _queuedMedicines.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_queuedMedicines.isEmpty) {
      showAppDialog(
        context: context,
        title: 'Medication Required',
        message: 'Please add at least one medication',
        type: DialogType.error,
      );
      return;
    }

    final state = ref.read(doctorProvider);
    if (state.selectedAppointment == null) return;

    final medicinesStr = _queuedMedicines.map((m) => m.name).join(', ');
    final dosageStr = _queuedMedicines.map((m) => '${m.name}: ${m.dosage} • ${m.frequency}').join('\n');

    final prescription = PrescriptionEntity(
      id: const Uuid().v4(),
      appointmentId: state.selectedAppointment!.id,
      diagnosis: _diagnosisController.text.trim(),
      medicines: medicinesStr,
      dosage: dosageStr,
      notes: _notesController.text.trim(),
    );

    final success = await ref.read(doctorProvider.notifier).addPrescription(prescription);

    if (success && mounted) {
      showAppDialog(
        context: context,
        title: 'Success',
        message: 'Prescription added and visit completed',
        type: DialogType.success,
        onConfirm: () => context.go('/doctor'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorProvider);
    final patient = state.selectedPatient;
    final appointment = state.selectedAppointment;

    if (patient == null || appointment == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No patient selected'),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () => context.go(DoctorRouter.dashboard),
                child: const Text('Back to Queue')),
          ],
        ),
      );
    }

    ref.listen(doctorProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(
          context: context,
          title: 'Error',
          message: next.error!,
          type: DialogType.error,
        );
        ref.read(doctorProvider.notifier).clearError();
      }
    });

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
                  // Merged Patient Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            AppColors.primaryLight.withValues(alpha: 0.2),
                        child: Text(
                          patient.name.isNotEmpty
                              ? patient.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(patient.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                                '${patient.phone} • Reason: ${appointment.reason}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  const Row(
                    children: [
                      Icon(Icons.description_outlined,
                          size: 18, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text('PRESCRIPTION DETAILS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              letterSpacing: 1.1)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text('DIAGNOSIS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _diagnosisController,
                    hintText: 'Enter patient diagnosis...',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  // Medication Add Section
                  const Text('MEDICATION NAME',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _medNameController,
                    hintText: 'e.g. Amoxicillin',
                  ),
                  const SizedBox(height: 20),

                  const Text('DOSAGE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ChoiceChip(
                          label: '250mg',
                          selected: _selectedDosage == '250mg',
                          onSelected: (s) =>
                              setState(() => _selectedDosage = '250mg')),
                      const SizedBox(width: 8),
                      _ChoiceChip(
                          label: '500mg',
                          selected: _selectedDosage == '500mg',
                          onSelected: (s) =>
                              setState(() => _selectedDosage = '500mg')),
                      const SizedBox(width: 8),
                      _ChoiceChip(
                          label: 'Custom',
                          selected: _selectedDosage == 'Custom',
                          onSelected: (s) =>
                              setState(() => _selectedDosage = 'Custom')),
                    ],
                  ),
                  if (_selectedDosage == 'Custom') ...[
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _customDosageController,
                      hintText: 'Enter custom dosage...',
                    ),
                  ],
                  const SizedBox(height: 20),

                  const Text('FREQUENCY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ChoiceChip(
                          label: '1x Daily',
                          selected: _selectedFrequency == '1x Daily',
                          onSelected: (s) =>
                              setState(() => _selectedFrequency = '1x Daily')),
                      const SizedBox(width: 8),
                      _ChoiceChip(
                          label: '2x Daily',
                          selected: _selectedFrequency == '2x Daily',
                          onSelected: (s) =>
                              setState(() => _selectedFrequency = '2x Daily')),
                      const SizedBox(width: 8),
                      _ChoiceChip(
                          label: '3x Daily',
                          selected: _selectedFrequency == '3x Daily',
                          onSelected: (s) =>
                              setState(() => _selectedFrequency = '3x Daily')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add to Queue Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _addMedicine,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('ADD TO QUEUE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sidebar,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Queued Section
                  if (_queuedMedicines.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QUEUED (${_queuedMedicines.length})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          ...List.generate(_queuedMedicines.length, (index) {
                            final m = _queuedMedicines[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: AppColors.background,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                        Icons.medical_services_outlined,
                                        size: 16,
                                        color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(m.name.toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13)),
                                        Text('${m.dosage} • ${m.frequency}',
                                            style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeMedicine(index),
                                    icon: const Icon(Icons.close,
                                        size: 18,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  const Text('ADDITIONAL NOTES',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _notesController,
                    maxLines: 2,
                    hintText: 'E.g., Drink plenty of water...',
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => context.go('/doctor'),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back to Queue'),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary),
                      ),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _save,
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text('Save & Complete Visit'),
                        ),
                      ),
                    ],
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

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const _ChoiceChip({required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: const Color(0xFF1E293B), // Dark blue from image
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textPrimary,
        fontSize: 13,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      showCheckmark: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      side: BorderSide(color: selected ? Colors.transparent : AppColors.border),
      backgroundColor: Colors.white,
    );
  }
}
