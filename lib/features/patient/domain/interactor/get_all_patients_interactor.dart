import '../../../../core/domain/entities/patient_entity.dart';
import '../repository/patient_repository.dart';

class GetAllPatientsInteractor {
  final PatientRepository _repository;

  GetAllPatientsInteractor(this._repository);

  Future<List<PatientEntity>> execute() async {
    return await _repository.getAllPatients();
  }
}
