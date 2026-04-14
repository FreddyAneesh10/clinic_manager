import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';
import '../domain/sorter/appointment_sort_strategy.dart';

/// Contract for fetching appointment data (DIP).
abstract class GetAppointmentsInteractor {
  Future<List<AppointmentEntity>> execute();
}

/// Implementation of the GetAppointments use case.
class GetAppointmentsInteractorImpl implements GetAppointmentsInteractor {
  final AppointmentRepository _repository;
  final AppointmentSortStrategy _sorter;

  GetAppointmentsInteractorImpl(this._repository, this._sorter);

  @override
  Future<List<AppointmentEntity>> execute() async {
    final appointments = await _repository.getAppointments();
    
    // OCP: Sorting strategy is now injected, making the class open for 
    // extension and closed for modification.
    _sorter.sort(appointments);
    
    return appointments;
  }
}
