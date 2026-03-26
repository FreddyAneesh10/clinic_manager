import 'package:uuid/uuid.dart';
import '../../domain/entities/prescription_entity.dart';

class QueuedMedicine {
  final String name;
  final String dosage;
  final String frequency;

  QueuedMedicine({required this.name, required this.dosage, required this.frequency});
}

class AddPrescriptionHandler {
  QueuedMedicine? buildQueuedMedicine({
    required String name,
    required String selectedDosage,
    required String customDosage,
    required String frequency,
  }) {
    final medName = name.trim();
    if (medName.isEmpty) return null;

    final dosage = selectedDosage == 'Custom' ? customDosage.trim() : selectedDosage;
    if (dosage.isEmpty) return null;

    return QueuedMedicine(name: medName, dosage: dosage, frequency: frequency);
  }

  String? validatePrescription({
    required String diagnosis,
    required List<QueuedMedicine> queuedMedicines,
  }) {
    if (diagnosis.trim().isEmpty) return 'Please enter patient diagnosis';
    if (queuedMedicines.isEmpty) return 'Please add at least one medication';
    return null;
  }

  PrescriptionEntity buildPrescriptionEntity({
    required String appointmentId,
    required String diagnosis,
    required List<QueuedMedicine> queuedMedicines,
    required String notes,
  }) {
    final medicinesStr = queuedMedicines.map((m) => m.name).join(', ');
    final dosageStr = queuedMedicines.map((m) => '${m.name}: ${m.dosage} • ${m.frequency}').join('\n');

    return PrescriptionEntity(
      id: const Uuid().v4(),
      appointmentId: appointmentId,
      diagnosis: diagnosis.trim(),
      medicines: medicinesStr,
      dosage: dosageStr,
      notes: notes.trim(),
    );
  }
}
