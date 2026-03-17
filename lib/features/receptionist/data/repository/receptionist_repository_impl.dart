import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../domain/repository/receptionist_repository.dart';
import '../datasource/receptionist_datasource.dart';

class ReceptionistRepositoryImpl implements ReceptionistRepository {
  final ReceptionistDataSource _dataSource;

  ReceptionistRepositoryImpl(this._dataSource);

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    return _dataSource.addAppointment(appointment);
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    return _dataSource.getAppointments();
  }

  @override
  Future<List<PatientEntity>> getAllPatients() async {
    return _dataSource.getAllPatients();
  }

  @override
  Future<void> registerPatient(PatientEntity patient) async {
    return _dataSource.registerPatient(patient);
  }
}
