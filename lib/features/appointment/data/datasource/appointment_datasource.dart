import 'package:hive/hive.dart';
import '../../../../core/domain/entities/appointment_entity.dart';

class AppointmentDataSource {
  final Box<AppointmentEntity> _appointmentBox =
      Hive.box<AppointmentEntity>('appointments');

  Future<void> addAppointment(AppointmentEntity appointment) async {
    await _appointmentBox.put(appointment.id, appointment);
  }

  Future<List<AppointmentEntity>> getAppointments() async {
    return _appointmentBox.values.toList();
  }
}
