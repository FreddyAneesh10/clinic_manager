import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';

/// Contract for adding an appointment (DIP).
abstract class AddAppointmentInteractor {
  Future<void> execute(AppointmentEntity appointment);
}

/// Implementation of the AddAppointment use case.
class AddAppointmentInteractorImpl implements AddAppointmentInteractor {
  final AppointmentRepository _repository;

  AddAppointmentInteractorImpl(this._repository);

  @override
  Future<void> execute(AppointmentEntity appointment) async {
    _validate(appointment);
    await _repository.addAppointment(appointment);
  }

  /// SRP: Encapsulated validation logic separately.
  void _validate(AppointmentEntity appointment) {
    if (appointment.patientName.trim().isEmpty) {
      throw Exception('Patient Name is required');
    }
    if (appointment.time.trim().isEmpty) {
      throw Exception('Appointment Time is required');
    }
  }
}
