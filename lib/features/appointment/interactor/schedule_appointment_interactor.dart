import '../../patient/domain/entities/patient_entity.dart';
import '../../patient/domain/repository/patient_repository.dart';
import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';

/// Contract for scheduling a medical appointment (DIP).
abstract class ScheduleAppointmentInteractor {
  Future<void> execute(AppointmentEntity appointment);
}

/// Orchestrator for registering a patient and scheduling their appointment.
class ScheduleAppointmentInteractorImpl implements ScheduleAppointmentInteractor {
  final AppointmentRepository _appointmentRepository;
  final PatientRepository _patientRepository;

  ScheduleAppointmentInteractorImpl(
    this._appointmentRepository,
    this._patientRepository,
  );

  @override
  Future<void> execute(AppointmentEntity appointment) async {
    // SRP: Entity mapping encapsulated in a specific helper method.
    final patient = _mapToPatientEntity(appointment);

    // Orchestrating two separate repository operations as a single use case.
    await _patientRepository.registerPatient(patient);
    await _appointmentRepository.addAppointment(appointment);
  }

  /// SRP: Decouples the mapping logic from the main execute orchestration.
  PatientEntity _mapToPatientEntity(AppointmentEntity appointment) {
    return PatientEntity(
      id: appointment.patientId,
      name: appointment.patientName,
      phone: appointment.phone,
    );
  }
}
