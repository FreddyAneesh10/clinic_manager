import '../../../../core/domain/entities/patient_entity.dart';
import '../repository/receptionist_repository.dart';

class RegisterPatientInteractor {
  final ReceptionistRepository _repository;

  RegisterPatientInteractor(this._repository);

  Future<void> execute(PatientEntity patient) async {
    if (patient.name.isEmpty || patient.phone.isEmpty) {
      throw Exception('Name and Phone are required');
    }
    await _repository.registerPatient(patient);
  }
}
