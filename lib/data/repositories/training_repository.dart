import '../datasources/local/hive_database.dart';
import '../models/training.dart';
import '../../domain/entities/training_entity.dart';

class TrainingRepository {
  final HiveDatabase _database = HiveDatabase();

  List<TrainingModel> getAllTrainings() => _database.getAllTrainings();

  List<TrainingModel> getTrainingsByPoste(String poste) {
    return _database.getAllTrainings()
        .where((training) => training.linkedPoste.toLowerCase().contains(poste.toLowerCase()))
        .toList();
  }

  TrainingModel? getTrainingById(String id) => _database.getTrainingById(id);

  Future<void> addTraining(TrainingEntity training) async {
    final trainingModel = TrainingModel.fromEntity(training);
    await _database.addTraining(trainingModel);
  }

  Future<void> updateTraining(TrainingModel training) async {
    await _database.updateTraining(training);
  }

  Future<void> deleteTraining(String id) async {
    await _database.deleteTraining(id);
  }

  DateTime? getDeadline() => _database.getDeadline();

  Future<void> setDeadline(DateTime deadline) async {
    await _database.setDeadline(deadline);
  }
}
