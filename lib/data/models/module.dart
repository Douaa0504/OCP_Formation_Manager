import 'package:hive/hive.dart';
import '../../domain/entities/module_entity.dart';

part 'module.g.dart';

@HiveType(typeId: 1)
class ModuleModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int order;

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
  });

  factory ModuleModel.fromEntity(ModuleEntity entity) {
    return ModuleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      order: entity.order,
    );
  }

  ModuleEntity toEntity() {
    return ModuleEntity(
      id: id,
      title: title,
      description: description,
      order: order,
    );
  }
}
