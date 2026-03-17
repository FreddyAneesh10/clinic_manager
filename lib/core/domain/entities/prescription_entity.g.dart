// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionEntityAdapter extends TypeAdapter<PrescriptionEntity> {
  @override
  final int typeId = 3;

  @override
  PrescriptionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionEntity(
      id: fields[0] as String,
      appointmentId: fields[1] as String,
      diagnosis: fields[2] as String,
      medicines: fields[3] as String,
      dosage: fields[4] as String,
      notes: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.appointmentId)
      ..writeByte(2)
      ..write(obj.diagnosis)
      ..writeByte(3)
      ..write(obj.medicines)
      ..writeByte(4)
      ..write(obj.dosage)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
