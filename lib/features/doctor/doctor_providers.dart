import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/doctor_datasource.dart';
import './data/repository/doctor_repository_impl.dart';
import './domain/repository/doctor_repository.dart';
import './domain/interactor/add_prescription_interactor.dart';
import './domain/interactor/complete_visit_interactor.dart';
import './domain/interactor/get_patient_details_interactor.dart';
import './domain/interactor/get_queue_interactor.dart';
import './presentation/presenter/doctor_presenter.dart';

// DataSource
final doctorDataSourceProvider = Provider<DoctorDataSource>((ref) {
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
  return GetQueueInteractor(repository);
});

final getPatientDetailsInteractorProvider = Provider<GetPatientDetailsInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return GetPatientDetailsInteractor(repository);
});

final addPrescriptionInteractorProvider = Provider<AddPrescriptionInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return AddPrescriptionInteractor(repository);
});

final completeVisitInteractorProvider = Provider<CompleteVisitInteractor>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return CompleteVisitInteractor(repository);
});

// Presenter
final doctorProvider = StateNotifierProvider<DoctorPresenter, DoctorState>((ref) {
  return DoctorPresenter(
    ref.watch(getQueueInteractorProvider),
    ref.watch(getPatientDetailsInteractorProvider),
    ref.watch(addPrescriptionInteractorProvider),
    ref.watch(completeVisitInteractorProvider),
  );
});
