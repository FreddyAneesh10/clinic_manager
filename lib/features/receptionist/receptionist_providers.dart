import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../patient/patient_providers.dart';
import './presentation/presenter/receptionist_presenter.dart';

// Presenter (StateNotifierProvider)
final receptionistProvider =
    StateNotifierProvider<ReceptionistPresenter, ReceptionistState>((ref) {
  return ReceptionistPresenter(
    ref.watch(registerPatientInteractorProvider),
    ref.watch(getAllPatientsInteractorProvider),
  );
});
//Creates and connects all layers
//To avoid manual object creation everywhere
//This is Dependency Injection
