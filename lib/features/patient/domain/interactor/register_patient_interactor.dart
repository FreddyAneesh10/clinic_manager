import '../../../../core/domain/entities/patient_entity.dart';
import '../repository/patient_repository.dart';

class RegisterPatientInteractor {
  final PatientRepository _repository;

  RegisterPatientInteractor(this._repository);

  Future<void> execute(PatientEntity patient) async {
    await _repository.registerPatient(patient);
  }
}
