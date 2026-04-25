import 'package:flutter/material.dart';
import '../../data/models/training.dart';
import '../../data/models/attendance.dart';
import '../../data/models/enrollment.dart';
import '../../domain/usecases/training_usecases.dart';
import '../../data/repositories/training_repository.dart';
import '../../core/utils/helpers.dart';
import '../../data/datasources/local/hive_database.dart';

class TrainingProvider with ChangeNotifier {
  final TrainingUseCases _trainingUseCases = TrainingUseCases();
  final TrainingRepository _trainingRepo = TrainingRepository();
  final HiveDatabase _db = HiveDatabase();

  List<TrainingModel> _trainings = [];
  TrainingModel? _selectedTraining;
  DateTime? _deadline;
  bool _isLoading = false;

  List<TrainingModel> get trainings => _trainings;
  TrainingModel? get selectedTraining => _selectedTraining;
  DateTime? get deadline => _deadline;
  bool get isLoading => _isLoading;
  bool get isDeadlinePassed => Helpers.isDeadlinePassed(_deadline);

  Future<void> loadTrainings(String poste, String employeeId) async {
    _isLoading = true;
    notifyListeners();

    _trainings = _trainingUseCases.getEmployeeTrainings(poste);
    _selectedTraining = _trainingUseCases.getSelectedTraining(employeeId);
    _deadline = _trainingRepo.getDeadline();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectTraining(String employeeId, String trainingId) async {
    await _trainingUseCases.selectTraining(employeeId, trainingId);
    _selectedTraining = _trainingRepo.getTrainingById(trainingId);
    notifyListeners();
  }

  EnrollmentModel? getEnrollment(String employeeId, String trainingId) {
    return _db.getEnrollment(employeeId, trainingId);
  }

  List<AttendanceModel> getModuleAttendances(String employeeId, String moduleId) {
    return _db.getAttendanceByEmployeeAndModule(employeeId, moduleId);
  }

  int getUnreadMessageCount(String userId) {
    return _db.getUnreadMessageCount(userId);
  }
}
