import '../domain/repository/doctor_repository.dart';

class CompleteVisitInteractor {
  final DoctorRepository _repository;

  CompleteVisitInteractor(this._repository);

  Future<void> execute(String appointmentId) async {
    await _repository.completeVisit(appointmentId);
  }
}
