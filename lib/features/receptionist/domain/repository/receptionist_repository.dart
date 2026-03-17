import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';

abstract class ReceptionistRepository {
  Future<void> registerPatient(PatientEntity patient);
  Future<List<PatientEntity>> getAllPatients();
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<List<AppointmentEntity>> getAppointments();
}
