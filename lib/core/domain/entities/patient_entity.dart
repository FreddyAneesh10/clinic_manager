import 'package:hive/hive.dart';

part 'patient_entity.g.dart';

@HiveType(typeId: 1)
class PatientEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  PatientEntity({
    required this.id,
    required this.name,
    required this.phone,
  });
}
