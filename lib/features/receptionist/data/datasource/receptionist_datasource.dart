import 'package:hive/hive.dart';
import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';

class ReceptionistDataSource {
  final Box<PatientEntity> _patientBox = Hive.box<PatientEntity>('patients');
  final Box<AppointmentEntity> _appointmentBox = Hive.box<AppointmentEntity>('appointments');

  Future<void> registerPatient(PatientEntity patient) async {
    await _patientBox.put(patient.id, patient);
  }

  Future<List<PatientEntity>> getAllPatients() async {
    return _patientBox.values.toList();
  }

  Future<void> addAppointment(AppointmentEntity appointment) async {
    await _appointmentBox.put(appointment.id, appointment);
  }

  Future<List<AppointmentEntity>> getAppointments() async {
    return _appointmentBox.values.toList();
  }
}
