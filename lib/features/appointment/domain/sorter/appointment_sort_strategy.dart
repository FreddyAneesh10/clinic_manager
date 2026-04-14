import '../entities/appointment_entity.dart';

/// Strategy for sorting appointments.
/// 
/// This allows the system to be OPEN for extension (new sorting criteria)
/// but CLOSED for modification (no need to change the interactor).
abstract class AppointmentSortStrategy {
  void sort(List<AppointmentEntity> appointments);
}

/// Default sorting strategy: Sorts by time string.
class TimeSortStrategy implements AppointmentSortStrategy {
  @override
  void sort(List<AppointmentEntity> appointments) {
    // Current behavior: sorts based on the time string value
    appointments.sort((a, b) => a.time.compareTo(b.time));
  }
}
