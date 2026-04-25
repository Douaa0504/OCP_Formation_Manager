import 'module_entity.dart';

class TrainingEntity {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String target;
  final String linkedPoste;
  final List<ModuleEntity> modules;
  final DateTime? deadlineDate;

  TrainingEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.target,
    required this.linkedPoste,
    required this.modules,
    this.deadlineDate,
  });
}
