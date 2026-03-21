import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<List<AppointmentEntity>> getAppointments();
}
