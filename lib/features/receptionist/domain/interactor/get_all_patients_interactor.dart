import '../../../../core/domain/entities/patient_entity.dart';
import '../repository/receptionist_repository.dart';

class GetAllPatientsInteractor {
  final ReceptionistRepository _repository;

  GetAllPatientsInteractor(this._repository);

  Future<List<PatientEntity>> execute() async {
    return await _repository.getAllPatients();
  }
}
