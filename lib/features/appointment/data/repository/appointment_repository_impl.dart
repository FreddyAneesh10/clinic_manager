import '../../../../core/domain/entities/appointment_entity.dart';
import '../../domain/repository/appointment_repository.dart';
import '../datasource/appointment_datasource.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentDataSource _dataSource;

  AppointmentRepositoryImpl(this._dataSource);

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    return _dataSource.addAppointment(appointment);
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    return _dataSource.getAppointments();
  }
}
