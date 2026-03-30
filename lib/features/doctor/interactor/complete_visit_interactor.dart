import '../domain/repository/doctor_repository.dart';

abstract class CompleteVisitInteractor {
  Future<void> execute(String appointmentId);
}

class CompleteVisitInteractorImpl implements CompleteVisitInteractor {
  final DoctorRepository _repository;

  CompleteVisitInteractorImpl(this._repository);

  @override
  Future<void> execute(String appointmentId) async {
    await _repository.completeVisit(appointmentId);
  }
}
