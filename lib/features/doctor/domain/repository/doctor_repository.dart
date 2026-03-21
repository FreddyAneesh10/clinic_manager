import '../../../appointment/domain/entities/appointment_entity.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../entities/prescription_entity.dart';

abstract class DoctorRepository {
  Future<List<AppointmentEntity>> getQueue();
  Future<PatientEntity?> getPatientDetails(String patientId);
  Future<void> addPrescription(PrescriptionEntity prescription);
  Future<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId);
  Future<void> completeVisit(String appointmentId);
  Future<void> initiateConsultation(String appointmentId);
}
