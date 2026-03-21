import '../../../appointment/domain/entities/appointment_entity.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../../appointment/domain/entities/appointment_status.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repository/doctor_repository.dart';
import '../datasource/doctor_datasource.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final IDoctorDataSource _dataSource;

  DoctorRepositoryImpl(this._dataSource);

  @override
  Future<void> addPrescription(PrescriptionEntity prescription) async {
    return _dataSource.addPrescription(prescription);
  }

  @override
  Future<void> completeVisit(String appointmentId) async {
    return _dataSource.updateAppointmentStatus(appointmentId, AppointmentStatus.completed.value);
  }

  @override
  Future<void> initiateConsultation(String appointmentId) async {
    return _dataSource.updateAppointmentStatus(appointmentId, AppointmentStatus.inConsultation.value);
  }

  @override
  Future<PatientEntity?> getPatientDetails(String patientId) async {
    return _dataSource.getPatientDetails(patientId);
  }

  @override
  Future<List<AppointmentEntity>> getQueue() async {
    return _dataSource.getQueue();
  }

  @override
  Future<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId) async {
    return _dataSource.getPrescriptionsForPatient(patientId);
  }
}
