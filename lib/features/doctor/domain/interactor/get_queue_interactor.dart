import '../../../../core/domain/entities/appointment_entity.dart';
import '../repository/doctor_repository.dart';

class GetQueueInteractor {
  final DoctorRepository _repository;

  GetQueueInteractor(this._repository);

  Future<List<AppointmentEntity>> execute() async {
    final appointments = await _repository.getQueue();
    // Sort logic (waiting first, then in consultation, completed last)
    appointments.sort((a, b) {
      final statusMap = {'in_consultation': 0, 'waiting': 1, 'completed': 2};
      final statusComparison = (statusMap[a.status] ?? 3).compareTo(statusMap[b.status] ?? 3);
      if (statusComparison != 0) return statusComparison;
      return a.time.compareTo(b.time);
    });
    return appointments;
  }
}
