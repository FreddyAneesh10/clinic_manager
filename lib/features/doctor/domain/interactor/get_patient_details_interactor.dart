import '../repository/doctor_repository.dart';

class GetPatientDetailsInteractor {
  final DoctorRepository _repository;

  GetPatientDetailsInteractor(this._repository);

  Future<Map<String, dynamic>> execute(String patientId) async {
    final patient = await _repository.getPatientDetails(patientId);
    if (patient == null) throw Exception('Patient not found');

    final prescriptions = await _repository.getPrescriptionsForPatient(patientId);
    
    return {
      'patient': patient,
      'prescriptions': prescriptions,
    };
  }
}
