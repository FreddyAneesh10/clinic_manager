import '../../../../core/domain/entities/patient_entity.dart';

abstract class PatientRepository {
  Future<void> registerPatient(PatientEntity patient);
  Future<List<PatientEntity>> getAllPatients();
  Future<PatientEntity?> getPatientById(String id);
}
