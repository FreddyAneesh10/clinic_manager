import '../../patient/domain/entities/patient_entity.dart';
import '../../patient/interactor/register_patient_interactor.dart';
import '../domain/entities/appointment_entity.dart';
import '../domain/repository/appointment_repository.dart';

class ScheduleAppointmentInteractor {
  final AppointmentRepository _appointmentRepository;
  final RegisterPatientInteractor _registerPatientInteractor;

  ScheduleAppointmentInteractor(
    this._appointmentRepository,
    this._registerPatientInteractor,
  );

  Future<void> execute(AppointmentEntity appointment) async {
    // 1. Create PatientEntity from appointment info for registration
    final patient = PatientEntity(
      id: appointment.patientId,
      name: appointment.patientName,
      phone: appointment.phone,
    );

    // 2. Register the patient
    await _registerPatientInteractor.execute(patient);

    // 3. Add the appointment
    await _appointmentRepository.addAppointment(appointment);
  }
}
