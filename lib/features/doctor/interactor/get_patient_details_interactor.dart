import '../domain/entities/patient_visit_details.dart';
import '../domain/repository/doctor_repository.dart';

class GetPatientDetailsInteractor {
  final DoctorRepository _repository;

  GetPatientDetailsInteractor(this._repository);

  Future<PatientVisitDetails> execute(String patientId) async {
    final patient = await _repository.getPatientDetails(patientId);
    if (patient == null) throw Exception('Patient not found');

    final prescriptions = await _repository.getPrescriptionsForPatient(patientId);
    
    return PatientVisitDetails(
      patient: patient,
      prescriptions: prescriptions,
    );
  }
}
