import '../domain/entities/prescription_entity.dart';
import '../domain/repository/doctor_repository.dart';

class AddPrescriptionInteractor {
  final DoctorRepository _repository;

  AddPrescriptionInteractor(this._repository);

  Future<void> execute(PrescriptionEntity prescription) async {
    if (prescription.diagnosis.isEmpty || prescription.medicines.isEmpty) {
      throw Exception('Diagnosis and medicines are required');
    }
    await _repository.addPrescription(prescription);
  }
}
