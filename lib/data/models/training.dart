import 'package:hive/hive.dart';
import '../../domain/entities/training_entity.dart';
import 'module.dart';

part 'training.g.dart';

@HiveType(typeId: 2)
class TrainingModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String duration;
  @HiveField(4)
  final String target;
  @HiveField(5)
  final String linkedPoste;
  @HiveField(6)
  final List<ModuleModel> modules;
  @HiveField(7)
  final DateTime? deadlineDate;

  TrainingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.target,
    required this.linkedPoste,
    required this.modules,
    this.deadlineDate,
  });

  factory TrainingModel.fromEntity(TrainingEntity entity) {
    return TrainingModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      duration: entity.duration,
      target: entity.target,
      linkedPoste: entity.linkedPoste,
      modules: entity.modules.map((m) => ModuleModel.fromEntity(m)).toList(),
      deadlineDate: entity.deadlineDate,
    );
  }

  TrainingEntity toEntity() {
    return TrainingEntity(
      id: id,
      title: title,
      description: description,
      duration: duration,
      target: target,
      linkedPoste: linkedPoste,
      modules: modules.map((m) => m.toEntity()).toList(),
      deadlineDate: deadlineDate,
    );
  }
}
