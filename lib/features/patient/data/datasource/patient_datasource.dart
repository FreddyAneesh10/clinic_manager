import 'package:hive/hive.dart';
import '../../../../core/domain/entities/patient_entity.dart';

class PatientDataSource {
  final Box<PatientEntity> _patientBox = Hive.box<PatientEntity>('patients');

  Future<void> savePatient(PatientEntity patient) async {
    await _patientBox.put(patient.id, patient);
  }

  Future<List<PatientEntity>> getAllPatients() async {
    return _patientBox.values.toList();
  }

  Future<PatientEntity?> getPatientById(String id) async {
    return _patientBox.get(id);
  }
}
