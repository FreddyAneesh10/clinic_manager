import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_text_field.dart';
import 'labeled_field.dart';

class MedicationInput extends StatelessWidget {
  final TextEditingController controller, customDosageController;
  final String selectedDosage, selectedFrequency;
  final ValueChanged<String> onDosageChanged, onFrequencyChanged;
  final VoidCallback onAdd;

  const MedicationInput({
    super.key,
    required this.controller,
    required this.customDosageController,
    required this.selectedDosage,
    required this.selectedFrequency,
    required this.onDosageChanged,
    required this.onFrequencyChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LabeledField(label: 'MEDICATION NAME', child: CustomTextField(controller: controller, hintText: 'e.g. Amoxicillin')),
      const SizedBox(height: 20),
      LabeledField(
        label: 'DOSAGE',
        child: Row(
          children: ['250mg', '500mg', 'Custom'].map((d) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(d),
              selected: selectedDosage == d,
              onSelected: (_) => onDosageChanged(d),
              side: BorderSide(color: selectedDosage == d ? Colors.transparent : AppColors.border),
              selectedColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: selectedDosage == d ? Colors.white : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: selectedDosage == d ? FontWeight.bold : FontWeight.normal,
              ),
              showCheckmark: false,
            ),
          )).toList(),
        ),
      ),
      if (selectedDosage == 'Custom') ...[
        const SizedBox(height: 12),
        CustomTextField(controller: customDosageController, hintText: 'Enter custom dosage...'),
      ],
      const SizedBox(height: 20),
      LabeledField(
        label: 'FREQUENCY',
        child: Row(
          children: ['1x Daily', '2x Daily', '3x Daily'].map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: selectedFrequency == f,
              onSelected: (_) => onFrequencyChanged(f),
              side: BorderSide(color: selectedFrequency == f ? Colors.transparent : AppColors.border),
              selectedColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: selectedFrequency == f ? Colors.white : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: selectedFrequency == f ? FontWeight.bold : FontWeight.normal,
              ),
              showCheckmark: false,
            ),
          )).toList(),
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('ADD TO QUEUE'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebar, foregroundColor: Colors.white),
        ),
      ),
    ]);
  }
}
