import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/appointment_datasource.dart';
import './data/repository/appointment_repository_impl.dart';
import './domain/repository/appointment_repository.dart';
import './domain/interactor/add_appointment_interactor.dart';
import './domain/interactor/get_appointments_interactor.dart';
import './presentation/presenter/appointment_presenter.dart';
import '../patient/patient_providers.dart';

// DataSource
final appointmentDataSourceProvider = Provider<AppointmentDataSource>((ref) {
  return AppointmentDataSource();
});

// Repository
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final dataSource = ref.watch(appointmentDataSourceProvider);
  return AppointmentRepositoryImpl(dataSource);
});

// Interactors
final getAppointmentsInteractorProvider =
    Provider<GetAppointmentsInteractor>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return GetAppointmentsInteractor(repository);
});

final addAppointmentInteractorProvider =
    Provider<AddAppointmentInteractor>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AddAppointmentInteractor(repository);
});

// Presenter (StateNotifierProvider)
final appointmentProvider =
    StateNotifierProvider<AppointmentPresenter, AppointmentState>((ref) {
  return AppointmentPresenter(
    ref.watch(getAppointmentsInteractorProvider),
    ref.watch(addAppointmentInteractorProvider),
    ref.watch(registerPatientInteractorProvider),
  );
});
