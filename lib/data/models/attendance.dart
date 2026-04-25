import 'package:hive/hive.dart';
import '../../domain/entities/attendance_entity.dart';

part 'attendance.g.dart';

@HiveType(typeId: 3)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String employeeId;
  @HiveField(2)
  final String moduleId;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String status;
  @HiveField(5)
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.moduleId,
    required this.date,
    required this.status,
    this.notes,
  });

  bool get isPresent => status.toLowerCase() == 'present';

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      employeeId: entity.employeeId,
      moduleId: entity.moduleId,
      date: entity.date,
      status: entity.status,
      notes: entity.notes,
    );
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      employeeId: employeeId,
      moduleId: moduleId,
      date: date,
      status: status,
      notes: notes,
    );
  }
}
