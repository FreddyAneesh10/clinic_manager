import '../domain/entities/prescription_entity.dart';
import '../domain/repository/doctor_repository.dart';

abstract class FinalizeVisitInteractor {
  Future<void> execute(PrescriptionEntity prescription);
}

class FinalizeVisitInteractorImpl implements FinalizeVisitInteractor {
  final DoctorRepository _repository;

  FinalizeVisitInteractorImpl(this._repository);

  @override
  Future<void> execute(PrescriptionEntity prescription) async {
    // 1. Add prescription
    await _repository.addPrescription(prescription);

    // 2. Complete visit
    await _repository.completeVisit(prescription.appointmentId);
  }
}
