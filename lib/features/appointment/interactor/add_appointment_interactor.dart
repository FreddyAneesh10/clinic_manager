import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';

class AddAppointmentInteractor {
  final AppointmentRepository _repository;

  AddAppointmentInteractor(this._repository);
 
  Future<void> execute(AppointmentEntity appointment) async {
    if (appointment.patientName.isEmpty || appointment.time.isEmpty) {
      throw Exception('Patient Name and Time are required');
    }
 
    await _repository.addAppointment(appointment);
  }
}
