import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/appointment_entity.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../domain/interactor/add_appointment_interactor.dart';
import '../../domain/interactor/get_all_patients_interactor.dart';
import '../../domain/interactor/get_appointments_interactor.dart';
import '../../domain/interactor/register_patient_interactor.dart';

class ReceptionistState {
  final bool isLoading;
  final String? error;
  final List<AppointmentEntity> appointments;
  final List<PatientEntity> patients;
  final bool isSuccess;

  const ReceptionistState({
    this.isLoading = false,
    this.error,
    this.appointments = const [],
    this.patients = const [],
    this.isSuccess = false,
  });

  ReceptionistState copyWith({
    bool? isLoading,
    String? error,
    List<AppointmentEntity>? appointments,
    List<PatientEntity>? patients,
    bool? isSuccess,
  }) {
    return ReceptionistState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      appointments: appointments ?? this.appointments,
      patients: patients ?? this.patients,
      isSuccess: isSuccess ?? false, // Reset success flag on every state copy unless explicitly set
    );
  }
}

class ReceptionistPresenter extends StateNotifier<ReceptionistState> {
  final GetAppointmentsInteractor _getAppointmentsInteractor;
  final AddAppointmentInteractor _addAppointmentInteractor;
  final RegisterPatientInteractor _registerPatientInteractor;
  final GetAllPatientsInteractor _getAllPatientsInteractor;

  ReceptionistPresenter(
    this._getAppointmentsInteractor,
    this._addAppointmentInteractor,
    this._registerPatientInteractor,
    this._getAllPatientsInteractor,
  ) : super(const ReceptionistState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final appointments = await _getAppointmentsInteractor.execute();
      final patients = await _getAllPatientsInteractor.execute();
      state = state.copyWith(
        isLoading: false,
        appointments: appointments,
        patients: patients,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> registerPatient(PatientEntity patient) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _registerPatientInteractor.execute(patient);
      await loadDashboardData(); // Reload to get updated patient list
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
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
      
      await loadDashboardData(); // Reload to get updated data
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
