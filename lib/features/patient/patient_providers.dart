import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/patient_datasource.dart';
import './data/repository/patient_repository_impl.dart';
import './domain/repository/patient_repository.dart';
import './domain/interactor/get_all_patients_interactor.dart';
import './domain/interactor/register_patient_interactor.dart';

final patientDataSourceProvider = Provider<IPatientDataSource>((ref) {
  return PatientDataSource();
});

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  final dataSource = ref.watch(patientDataSourceProvider);
  return PatientRepositoryImpl(dataSource);
});

final registerPatientInteractorProvider = Provider<RegisterPatientInteractor>((ref) {
  final repository = ref.watch(patientRepositoryProvider);
  return RegisterPatientInteractor(repository);
});

final getAllPatientsInteractorProvider = Provider<GetAllPatientsInteractor>((ref) {
  final repository = ref.watch(patientRepositoryProvider);
  return GetAllPatientsInteractor(repository);
});
