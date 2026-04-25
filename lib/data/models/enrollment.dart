import 'package:hive/hive.dart';
import '../../domain/entities/enrollment_entity.dart';

part 'enrollment.g.dart';

@HiveType(typeId: 4)
class EnrollmentModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String employeeId;
  @HiveField(2)
  final String trainingId;
  @HiveField(3)
  final DateTime enrollmentDate;
  @HiveField(4)
  final double progress;
  @HiveField(5)
  final bool isCompleted;
  @HiveField(6)
  final List<String> completedModuleIds;

  EnrollmentModel({
    required this.id,
    required this.employeeId,
    required this.trainingId,
    required this.enrollmentDate,
    required this.progress,
    required this.isCompleted,
    this.completedModuleIds = const [],
  });

  factory EnrollmentModel.fromEntity(EnrollmentEntity entity) {
    return EnrollmentModel(
      id: entity.id,
      employeeId: entity.employeeId,
      trainingId: entity.trainingId,
      enrollmentDate: entity.enrollmentDate,
      progress: entity.progress,
      isCompleted: entity.isCompleted,
      completedModuleIds: entity.completedModuleIds,
    );
  }

  EnrollmentEntity toEntity() {
    return EnrollmentEntity(
      id: id,
      employeeId: employeeId,
      trainingId: trainingId,
      enrollmentDate: enrollmentDate,
      progress: progress,
      isCompleted: isCompleted,
      completedModuleIds: completedModuleIds,
    );
  }
}
