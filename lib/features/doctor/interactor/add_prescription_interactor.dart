import '../domain/entities/prescription_entity.dart';
import '../domain/repository/doctor_repository.dart';

/// Contract for adding a prescription (DIP).
abstract class AddPrescriptionInteractor {
  Future<void> execute(PrescriptionEntity prescription);
}

/// Implementation of the AddPrescription use case.
class AddPrescriptionInteractorImpl implements AddPrescriptionInteractor {
  final DoctorRepository _repository;

  AddPrescriptionInteractorImpl(this._repository);

  @override
  Future<void> execute(PrescriptionEntity prescription) async {
    _validate(prescription);
    await _repository.addPrescription(prescription);
  }

  /// SRP: Encapsulated validation logic.
  void _validate(PrescriptionEntity prescription) {
    if (prescription.diagnosis.trim().isEmpty ||
        prescription.medicines.isEmpty) {
      throw Exception('Diagnosis and medicines are required');
    }
  }
}
