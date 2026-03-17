import '../../../../core/domain/entities/appointment_entity.dart';
import '../repository/receptionist_repository.dart';

class AddAppointmentInteractor {
  final ReceptionistRepository _repository;

  AddAppointmentInteractor(this._repository);
 
  Future<void> execute(AppointmentEntity appointment) async {
    if (appointment.patientName.isEmpty || appointment.time.isEmpty) {
      throw Exception('Patient Name and Time are required');
    }
 
    await _repository.addAppointment(appointment);
  }
}
