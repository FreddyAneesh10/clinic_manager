import '../../../patient/domain/entities/patient_entity.dart';
import 'prescription_entity.dart';

class PatientVisitDetails {
  final PatientEntity patient;
  final List<PrescriptionEntity> prescriptions;

  const PatientVisitDetails({
    required this.patient,
    required this.prescriptions,
  });
}
