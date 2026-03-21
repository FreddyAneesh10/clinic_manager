import '../../domain/repository/patient_repository.dart';
import '../datasource/patient_datasource.dart';
import '../../domain/entities/patient_entity.dart';

class PatientRepositoryImpl implements PatientRepository {
  final IPatientDataSource _dataSource;

  PatientRepositoryImpl(this._dataSource);

  @override
  Future<void> registerPatient(PatientEntity patient) async {
    return await _dataSource.savePatient(patient);
  }

  @override
  Future<List<PatientEntity>> getAllPatients() async {
    return await _dataSource.getAllPatients();
  }

  @override
  Future<PatientEntity?> getPatientById(String id) async {
    return await _dataSource.getPatientById(id);
  }
}
