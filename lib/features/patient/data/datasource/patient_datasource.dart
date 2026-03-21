import 'package:hive/hive.dart';
import '../../domain/entities/patient_entity.dart';

abstract class IPatientDataSource {
  Future<void> savePatient(PatientEntity patient);
  Future<List<PatientEntity>> getAllPatients();
  Future<PatientEntity?> getPatientById(String id);
}

class PatientDataSource implements IPatientDataSource {
  final Box<PatientEntity> _patientBox = Hive.box<PatientEntity>('patients');

  @override
  Future<void> savePatient(PatientEntity patient) async {
    await _patientBox.put(patient.id, patient);
  }

  @override
  Future<List<PatientEntity>> getAllPatients() async {
    return _patientBox.values.toList();
  }

  @override
  Future<PatientEntity?> getPatientById(String id) async {
    return _patientBox.get(id);
  }
}
