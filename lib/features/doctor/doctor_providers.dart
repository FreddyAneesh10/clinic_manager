import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/doctor_datasource.dart';
import './data/repository/doctor_repository_impl.dart';
import './domain/repository/doctor_repository.dart';
import 'interactor/complete_visit_interactor.dart';
import 'interactor/get_patient_details_interactor.dart';
import 'interactor/get_queue_interactor.dart';
import './presentation/presenter/doctor_presenter.dart';

import 'interactor/finalize_visit_interactor.dart';

// DataSource
final doctorDataSourceProvider = Provider<IDoctorDataSource>((ref) {
  return DoctorDataSource();
});

// Repository
final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  final dataSource = ref.watch(doctorDataSourceProvider);
  return DoctorRepositoryImpl(dataSource);
});

// Interactors
final getQueueInteractorProvider = Provider<GetQueueInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetQueueInteractorImpl(repository);
});

final getPatientDetailsInteractorProvider =
    Provider<GetPatientDetailsInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetPatientDetailsInteractorImpl(repository);
});

final completeVisitInteractorProvider =
    Provider<CompleteVisitInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return CompleteVisitInteractorImpl(repository);
});

final finalizeVisitInteractorProvider =
    Provider<FinalizeVisitInteractor>((ref) {
  return FinalizeVisitInteractorImpl(ref.watch(doctorRepositoryProvider));
});

// Presenter
final doctorProvider =
    StateNotifierProvider<DoctorPresenter, DoctorState>((ref) {
  return DoctorPresenter(
    ref.watch(getQueueInteractorProvider),
    ref.watch(getPatientDetailsInteractorProvider),
    ref.watch(finalizeVisitInteractorProvider),
    ref.watch(completeVisitInteractorProvider),
  );
});
