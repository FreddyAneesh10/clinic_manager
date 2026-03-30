import '../../appointment/domain/entities/appointment_entity.dart';
import '../domain/repository/doctor_repository.dart';

/// Contract for fetching the current doctor's queue (DIP).
abstract class GetQueueInteractor {
  Future<List<AppointmentEntity>> execute();
}

/// Implementation of the GetQueue use case.
class GetQueueInteractorImpl implements GetQueueInteractor {
  final DoctorRepository _repository;

  GetQueueInteractorImpl(this._repository);

  @override
  Future<List<AppointmentEntity>> execute() async {
    final appointments = await _repository.getQueue();
    
    // SRP: Sorting logic encapsulated separately.
    _sortQueue(appointments);
    
    return appointments;
  }

  /// SRP/OCP: Encapsulated logic for sorting patients by status and time.
  void _sortQueue(List<AppointmentEntity> appointments) {
    appointments.sort((a, b) {
      final statusMap = {'in_consultation': 0, 'waiting': 1, 'completed': 2};
      final statusComparison =
          (statusMap[a.status] ?? 3).compareTo(statusMap[b.status] ?? 3);
      if (statusComparison != 0) return statusComparison;
      return a.time.compareTo(b.time);
    });
  }
}
