import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../../patient/interactor/get_all_patients_interactor.dart';
import '../../../patient/interactor/register_patient_interactor.dart';

class ReceptionistState {
  final bool isLoading;
  final String? error;
  final List<PatientEntity> patients;
  final bool isSuccess;

  const ReceptionistState({
    this.isLoading = false,
    this.error,
    this.patients = const [],
    this.isSuccess = false,
  });

  ReceptionistState copyWith({
    bool? isLoading,
    String? error,
    List<PatientEntity>? patients,
    bool? isSuccess,
  }) {
    return ReceptionistState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      patients: patients ?? this.patients,
      isSuccess: isSuccess ?? false,
    );
  }
}

class ReceptionistPresenter extends StateNotifier<ReceptionistState> {
  final RegisterPatientInteractor _registerPatientInteractor;
  final GetAllPatientsInteractor _getAllPatientsInteractor;

  ReceptionistPresenter(
    this._registerPatientInteractor,
    this._getAllPatientsInteractor,
  ) : super(const ReceptionistState()) {
    loadPatients();
  }

  Future<void> loadPatients() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final patients = await _getAllPatientsInteractor.execute();
      state = state.copyWith(
        isLoading: false,
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
      await loadPatients();
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
//Controller between UI and business layer

