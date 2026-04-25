import '../../data/repositories/training_repository.dart';
import '../../data/repositories/database_repository.dart';
import '../../data/models/training.dart';
import '../../data/models/enrollment.dart';
import '../../core/utils/helpers.dart';

class TrainingUseCases {
  final TrainingRepository _trainingRepo = TrainingRepository();
  final DatabaseRepository _dbRepo = DatabaseRepository();

  List<TrainingModel> getEmployeeTrainings(String poste) {
    return _trainingRepo.getTrainingsByPoste(poste);
  }

  TrainingModel? getSelectedTraining(String employeeId) {
    final enrollments = _dbRepo.getEnrollmentsByEmployee(employeeId);
    if (enrollments.isNotEmpty) {
      return _trainingRepo.getTrainingById(enrollments.first.trainingId);
    }
    return null;
  }

  bool canModifySelection(String employeeId) {
    final enrollments = _dbRepo.getEnrollmentsByEmployee(employeeId);
    if (enrollments.isEmpty) return true;

    final training = _trainingRepo.getTrainingById(enrollments.first.trainingId);
    return !Helpers.isDeadlinePassed(training?.deadlineDate);
  }

  Future<void> selectTraining(String employeeId, String trainingId) async {
    final enrollment = EnrollmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: employeeId,
      trainingId: trainingId,
      enrollmentDate: DateTime.now(),
      progress: 0.0,
      isCompleted: false,
    );
    await _dbRepo.addEnrollment(enrollment);
  }
}
