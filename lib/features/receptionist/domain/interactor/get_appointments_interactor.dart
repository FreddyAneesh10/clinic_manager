import '../../../../core/domain/entities/appointment_entity.dart';
import '../repository/receptionist_repository.dart';

class GetAppointmentsInteractor {
  final ReceptionistRepository _repository;

  GetAppointmentsInteractor(this._repository);

  Future<List<AppointmentEntity>> execute() async {
    final appointments = await _repository.getAppointments();
    // Sort by time (simple string sort since it's HH:MM AM/PM for this demo, 
    // ideally should use DateTime for strict sorting)
    appointments.sort((a, b) => a.time.compareTo(b.time));
    return appointments;
  }
}
