import 'package:hive/hive.dart';

part 'prescription_entity.g.dart';

@HiveType(typeId: 3)
class PrescriptionEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String appointmentId;

  @HiveField(2)
  String diagnosis;

  @HiveField(3)
  String medicines;

  @HiveField(4)
  String dosage;

  @HiveField(5)
  String notes;

  PrescriptionEntity({
    required this.id,
    required this.appointmentId,
    required this.diagnosis,
    required this.medicines,
    required this.dosage,
    required this.notes,
  });
}
