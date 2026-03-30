import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/appointment_datasource.dart';
import './data/repository/appointment_repository_impl.dart';
import './domain/repository/appointment_repository.dart';
import 'interactor/add_appointment_interactor.dart';
import 'interactor/get_appointments_interactor.dart';
import './presentation/presenter/appointment_presenter.dart';
import '../patient/patient_providers.dart';

import 'interactor/schedule_appointment_interactor.dart';

// DataSource
final appointmentDataSourceProvider = Provider<IAppointmentDataSource>((ref) {
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
  return GetAppointmentsInteractorImpl(repository);
});

final addAppointmentInteractorProvider =
    Provider<AddAppointmentInteractor>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AddAppointmentInteractorImpl(repository);
});

final scheduleAppointmentInteractorProvider =
    Provider<ScheduleAppointmentInteractor>((ref) {
  return ScheduleAppointmentInteractorImpl(
    ref.watch(appointmentRepositoryProvider),
    ref.watch(patientRepositoryProvider),
  );
});

// Presenter (StateNotifierProvider)
final appointmentProvider =
    StateNotifierProvider<AppointmentPresenter, AppointmentState>((ref) {
  return AppointmentPresenter(
    ref.watch(getAppointmentsInteractorProvider),
    ref.watch(scheduleAppointmentInteractorProvider),
  );
});
