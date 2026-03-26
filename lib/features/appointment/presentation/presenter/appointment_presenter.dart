import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../interactor/schedule_appointment_interactor.dart';
import '../../interactor/get_appointments_interactor.dart';

class AppointmentState {
  final bool isLoading;
  final String? error;
  final List<AppointmentEntity> appointments;
  final bool isSuccess;

  const AppointmentState({
    this.isLoading = false,
    this.error,
    this.appointments = const [],
    this.isSuccess = false,
  });

  AppointmentState copyWith({
    bool? isLoading,
    String? error,
    List<AppointmentEntity>? appointments,
    bool? isSuccess,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      appointments: appointments ?? this.appointments,
      isSuccess: isSuccess ?? false,
    );
  }
}

class AppointmentPresenter extends StateNotifier<AppointmentState> {
  final GetAppointmentsInteractor _getAppointmentsInteractor;
  final ScheduleAppointmentInteractor _scheduleAppointmentInteractor;

  AppointmentPresenter(
    this._getAppointmentsInteractor,
    this._scheduleAppointmentInteractor,
  ) : super(const AppointmentState()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final appointments = await _getAppointmentsInteractor.execute();
      state = state.copyWith(
        isLoading: false,
        appointments: appointments,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addAppointment(AppointmentEntity appointment) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _scheduleAppointmentInteractor.execute(appointment);

      await loadAppointments();
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
