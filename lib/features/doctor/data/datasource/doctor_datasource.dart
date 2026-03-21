import 'package:hive/hive.dart';
import '../../../appointment/domain/entities/appointment_entity.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../domain/entities/prescription_entity.dart';

abstract class IDoctorDataSource {
  Future<List<AppointmentEntity>> getQueue();
  Future<PatientEntity?> getPatientDetails(String patientId);
  Future<void> addPrescription(PrescriptionEntity prescription);
  Future<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId);
  Future<void> updateAppointmentStatus(String appointmentId, String status);
}

class DoctorDataSource implements IDoctorDataSource {
  final Box<PatientEntity> _patientBox = Hive.box<PatientEntity>('patients');
  final Box<AppointmentEntity> _appointmentBox = Hive.box<AppointmentEntity>('appointments');
  final Box<PrescriptionEntity> _prescriptionBox = Hive.box<PrescriptionEntity>('prescriptions');

  @override
  Future<List<AppointmentEntity>> getQueue() async {
    return _appointmentBox.values.toList();
  }

  @override
  Future<PatientEntity?> getPatientDetails(String patientId) async {
    return _patientBox.get(patientId);
  }

  @override
  Future<void> addPrescription(PrescriptionEntity prescription) async {
    await _prescriptionBox.put(prescription.id, prescription);
  }

  @override
  Future<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId) async {
    final appointmentsForPatient = _appointmentBox.values.where((a) => a.patientId == patientId).map((a) => a.id).toList();
    return _prescriptionBox.values.where((p) => appointmentsForPatient.contains(p.appointmentId)).toList();
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    final appointment = _appointmentBox.get(appointmentId);
    if (appointment != null) {
      appointment.status = status;
      await appointment.save();
    }
  }
}
