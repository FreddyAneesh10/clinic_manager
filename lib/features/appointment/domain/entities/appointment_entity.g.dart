// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentEntityAdapter extends TypeAdapter<AppointmentEntity> {
  @override
  final int typeId = 2;

  @override
  AppointmentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentEntity(
      id: fields[0] as String,
      patientId: fields[1] as String,
      patientName: fields[2] as String,
      phone: fields[3] as String,
      time: fields[4] as String,
      reason: fields[5] as String,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.patientName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.reason)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
