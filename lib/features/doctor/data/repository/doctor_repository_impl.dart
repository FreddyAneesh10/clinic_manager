import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../../../core/domain/entities/prescription_entity.dart';
import '../../domain/repository/doctor_repository.dart';
import '../datasource/doctor_datasource.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorDataSource _dataSource;

  DoctorRepositoryImpl(this._dataSource);

  @override
  Future<void> addPrescription(PrescriptionEntity prescription) async {
    return _dataSource.addPrescription(prescription);
  }

  @override
  Future<void> completeVisit(String appointmentId) async {
    return _dataSource.updateAppointmentStatus(appointmentId, 'completed');
  }

  @override
  Future<void> initiateConsultation(String appointmentId) async {
    return _dataSource.updateAppointmentStatus(appointmentId, 'in_consultation');
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
