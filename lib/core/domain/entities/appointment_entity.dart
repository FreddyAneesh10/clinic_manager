import 'package:hive/hive.dart';

part 'appointment_entity.g.dart';

@HiveType(typeId: 2)
class AppointmentEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String patientId;

  @HiveField(2)
  String patientName;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String time;

  @HiveField(5)
  String reason;

  @HiveField(6)
  String status; // 'waiting', 'in_consultation', 'completed'

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.phone,
    required this.time,
    required this.reason,
    this.status = 'waiting',
  });
}
