import 'package:hive/hive.dart';
import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../../../core/domain/entities/prescription_entity.dart';

class DoctorDataSource {
  final Box<PatientEntity> _patientBox = Hive.box<PatientEntity>('patients');
  final Box<AppointmentEntity> _appointmentBox = Hive.box<AppointmentEntity>('appointments');
  final Box<PrescriptionEntity> _prescriptionBox = Hive.box<PrescriptionEntity>('prescriptions');

  Future<List<AppointmentEntity>> getQueue() async {
    return _appointmentBox.values.toList();
  }

  Future<PatientEntity?> getPatientDetails(String patientId) async {
    return _patientBox.get(patientId);
  }

  Future<void> addPrescription(PrescriptionEntity prescription) async {
    await _prescriptionBox.put(prescription.id, prescription);
  }

  Future<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId) async {
    final appointmentsForPatient = _appointmentBox.values.where((a) => a.patientId == patientId).map((a) => a.id).toList();
    return _prescriptionBox.values.where((p) => appointmentsForPatient.contains(p.appointmentId)).toList();
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    final appointment = _appointmentBox.get(appointmentId);
    if (appointment != null) {
      appointment.status = status;
      await appointment.save();
    }
  }
}
