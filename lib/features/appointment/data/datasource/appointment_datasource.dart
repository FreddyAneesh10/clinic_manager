import 'package:hive/hive.dart';
import '../../domain/entities/appointment_entity.dart';

abstract class IAppointmentDataSource {
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<List<AppointmentEntity>> getAppointments();
}

class AppointmentDataSource implements IAppointmentDataSource {
  final Box<AppointmentEntity> _appointmentBox =
      Hive.box<AppointmentEntity>('appointments');

  @override
  Future<void> addAppointment(AppointmentEntity appointment) async {
    await _appointmentBox.put(appointment.id, appointment);
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    return _appointmentBox.values.toList();
  }
}
