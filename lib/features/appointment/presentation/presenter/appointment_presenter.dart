import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../domain/interactor/add_appointment_interactor.dart';
import '../../domain/interactor/get_appointments_interactor.dart';
import '../../../patient/domain/interactor/register_patient_interactor.dart';

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
  final AddAppointmentInteractor _addAppointmentInteractor;
  final RegisterPatientInteractor _registerPatientInteractor;

  AppointmentPresenter(
    this._getAppointmentsInteractor,
    this._addAppointmentInteractor,
    this._registerPatientInteractor,
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
      // Create PatientEntity from appointment info for registration
      final patient = PatientEntity(
        id: appointment.patientId,
        name: appointment.patientName,
        phone: appointment.phone,
      );

      await _registerPatientInteractor.execute(patient);
      await _addAppointmentInteractor.execute(appointment);

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
