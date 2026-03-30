import '../domain/entities/patient_entity.dart';
import '../domain/repository/patient_repository.dart';

abstract class RegisterPatientInteractor {
  Future<void> execute(PatientEntity patient);
}

class RegisterPatientInteractorImpl implements RegisterPatientInteractor {
  final PatientRepository _repository;

  RegisterPatientInteractorImpl(this._repository);

  @override
  Future<void> execute(PatientEntity patient) async {
    await _repository.registerPatient(patient);
  }
}
