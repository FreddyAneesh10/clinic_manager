import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointment/domain/entities/appointment_entity.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/interactor/complete_visit_interactor.dart';
import '../../domain/interactor/finalize_visit_interactor.dart';
import '../../domain/interactor/get_patient_details_interactor.dart';
import '../../domain/interactor/get_queue_interactor.dart';

class DoctorState {
  final bool isLoading;
  final String? error;
  final List<AppointmentEntity> queue;
  final PatientEntity? selectedPatient;
  final AppointmentEntity? selectedAppointment;
  final List<PrescriptionEntity> patientPrescriptions;
  final bool isSuccess;

  const DoctorState({
    this.isLoading = false,
    this.error,
    this.queue = const [],
    this.selectedPatient,
    this.selectedAppointment,
    this.patientPrescriptions = const [],
    this.isSuccess = false,
  });

  DoctorState copyWith({
    bool? isLoading,
    String? error,
    List<AppointmentEntity>? queue,
    PatientEntity? selectedPatient,
    AppointmentEntity? selectedAppointment,
    List<PrescriptionEntity>? patientPrescriptions,
    bool? isSuccess,
  }) {
    return DoctorState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      queue: queue ?? this.queue,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedAppointment: selectedAppointment ?? this.selectedAppointment,
      patientPrescriptions: patientPrescriptions ?? this.patientPrescriptions,
      isSuccess: isSuccess ?? false,
    );
  }

  int get waitingCount => queue.where((a) => !a.isCompleted).length;
  int get completedCount => queue.where((a) => a.isCompleted).length;
  int get totalCount => queue.length;
}

class DoctorPresenter extends StateNotifier<DoctorState> {
  final GetQueueInteractor _getQueueInteractor;
  final GetPatientDetailsInteractor _getPatientDetailsInteractor;
  final FinalizeVisitInteractor _finalizeVisitInteractor;
  final CompleteVisitInteractor _completeVisitInteractor;

  DoctorPresenter(
    this._getQueueInteractor,
    this._getPatientDetailsInteractor,
    this._finalizeVisitInteractor,
    this._completeVisitInteractor,
  ) : super(const DoctorState()) {
    loadQueue();
  }

  Future<void> loadQueue() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final queue = await _getQueueInteractor.execute();
      state = state.copyWith(isLoading: false, queue: queue);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadPatientDetails(AppointmentEntity appointment) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedAppointment: appointment,
    );
    try {
      final details = await _getPatientDetailsInteractor.execute(appointment.patientId);
      state = state.copyWith(
        isLoading: false,
        selectedPatient: details.patient,
        patientPrescriptions: details.prescriptions,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addPrescription(PrescriptionEntity prescription) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _finalizeVisitInteractor.execute(prescription);
      await loadQueue();
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> completeVisit(String appointmentId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _completeVisitInteractor.execute(appointmentId);
      await loadQueue();
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
