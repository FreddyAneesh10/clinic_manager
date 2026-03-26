import '../domain/entities/patient_entity.dart';
import '../domain/repository/patient_repository.dart';

class RegisterPatientInteractor {
  final PatientRepository _repository;

  RegisterPatientInteractor(this._repository);

  Future<void> execute(PatientEntity patient) async {
    await _repository.registerPatient(patient);
  }
}
