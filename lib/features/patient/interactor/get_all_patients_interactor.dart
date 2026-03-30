import '../domain/entities/patient_entity.dart';
import '../domain/repository/patient_repository.dart';

abstract class GetAllPatientsInteractor {
  Future<List<PatientEntity>> execute();
}

class GetAllPatientsInteractorImpl implements GetAllPatientsInteractor {
  final PatientRepository _repository;

  GetAllPatientsInteractorImpl(this._repository);

  @override
  Future<List<PatientEntity>> execute() async {
    return await _repository.getAllPatients();
  }
}
