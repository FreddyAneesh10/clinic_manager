import '../domain/entities/prescription_entity.dart';
import '../domain/repository/doctor_repository.dart';

class FinalizeVisitInteractor {
  final DoctorRepository _repository;

  FinalizeVisitInteractor(this._repository);

  Future<void> execute(PrescriptionEntity prescription) async {
    // 1. Add prescription
    await _repository.addPrescription(prescription);

    // 2. Complete visit
    await _repository.completeVisit(prescription.appointmentId);
  }
}
