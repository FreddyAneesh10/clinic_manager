import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';

/// Contract for fetching appointment data (DIP).
abstract class GetAppointmentsInteractor {
  Future<List<AppointmentEntity>> execute();
}

/// Implementation of the GetAppointments use case.
class GetAppointmentsInteractorImpl implements GetAppointmentsInteractor {
  final AppointmentRepository _repository;

  GetAppointmentsInteractorImpl(this._repository);

  @override
  Future<List<AppointmentEntity>> execute() async {
    final appointments = await _repository.getAppointments();
    
    // SRP: Sorting logic encapsulated separately from fetch logic.
    _sortAppointments(appointments);
    
    return appointments;
  }

  /// Encapsulated sorting strategy to keep execute() focused on orchestration.
  void _sortAppointments(List<AppointmentEntity> appointments) {
    // Ideally use DateTime for robust sorting, but string compare for current demo.
    appointments.sort((a, b) => a.time.compareTo(b.time));
  }
}
