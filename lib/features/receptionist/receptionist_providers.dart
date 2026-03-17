import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/receptionist_datasource.dart';
import './data/repository/receptionist_repository_impl.dart';
import './domain/repository/receptionist_repository.dart';
import './domain/interactor/add_appointment_interactor.dart';
import './domain/interactor/get_all_patients_interactor.dart';
import './domain/interactor/get_appointments_interactor.dart';
import './domain/interactor/register_patient_interactor.dart';
import './presentation/presenter/receptionist_presenter.dart';

// DataSource
final receptionistDataSourceProvider = Provider<ReceptionistDataSource>((ref) {
  return ReceptionistDataSource();
});

// Repository
final receptionistRepositoryProvider = Provider<ReceptionistRepository>((ref) {
  final dataSource = ref.watch(receptionistDataSourceProvider);
  return ReceptionistRepositoryImpl(dataSource);
});

// Interactors
final getAppointmentsInteractorProvider = Provider<GetAppointmentsInteractor>((ref) {
  final repository = ref.watch(receptionistRepositoryProvider);
  return GetAppointmentsInteractor(repository);
});

final addAppointmentInteractorProvider = Provider<AddAppointmentInteractor>((ref) {
  final repository = ref.watch(receptionistRepositoryProvider);
  return AddAppointmentInteractor(repository);
});

final registerPatientInteractorProvider = Provider<RegisterPatientInteractor>((ref) {
  final repository = ref.watch(receptionistRepositoryProvider);
  return RegisterPatientInteractor(repository);
});

final getAllPatientsInteractorProvider = Provider<GetAllPatientsInteractor>((ref) {
  final repository = ref.watch(receptionistRepositoryProvider);
  return GetAllPatientsInteractor(repository);
});

// Presenter (StateNotifierProvider)
final receptionistProvider =
    StateNotifierProvider<ReceptionistPresenter, ReceptionistState>((ref) {
  return ReceptionistPresenter(
    ref.watch(getAppointmentsInteractorProvider),
    ref.watch(addAppointmentInteractorProvider),
    ref.watch(registerPatientInteractorProvider),
    ref.watch(getAllPatientsInteractorProvider),
  );
});
