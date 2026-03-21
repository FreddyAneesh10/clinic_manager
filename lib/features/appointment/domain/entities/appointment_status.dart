enum AppointmentStatus {
  waiting,
  inConsultation,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case AppointmentStatus.waiting:
        return 'waiting';
      case AppointmentStatus.inConsultation:
        return 'in_consultation';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
    }
  }

  static AppointmentStatus fromValue(String value) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AppointmentStatus.waiting,
    );
  }
}
