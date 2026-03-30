import '../domain/entities/patient_visit_details.dart';
import '../domain/repository/doctor_repository.dart';

/// Contract for fetching comprehensive patient visit history (DIP).
abstract class GetPatientDetailsInteractor {
  Future<PatientVisitDetails> execute(String patientId);
}

/// Implementation of the GetPatientDetails use case.
class GetPatientDetailsInteractorImpl implements GetPatientDetailsInteractor {
  final DoctorRepository _repository;

  GetPatientDetailsInteractorImpl(this._repository);

  @override
  Future<PatientVisitDetails> execute(String patientId) async {
    // Orchestrating multiple data fetches into a single domain aggregate.
    final patient = await _repository.getPatientDetails(patientId);
    if (patient == null) {
      throw Exception('Patient document not found');
    }

    final prescriptions =
        await _repository.getPrescriptionsForPatient(patientId);

    return PatientVisitDetails(
      patient: patient,
      prescriptions: prescriptions,
    );
  }
}
