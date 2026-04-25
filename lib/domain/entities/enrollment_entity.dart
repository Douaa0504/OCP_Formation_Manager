class EnrollmentEntity {
  final String id;
  final String employeeId;
  final String trainingId;
  final DateTime enrollmentDate;
  final double progress;
  final bool isCompleted;
  final List<String> completedModuleIds;

  EnrollmentEntity({
    required this.id,
    required this.employeeId,
    required this.trainingId,
    required this.enrollmentDate,
    required this.progress,
    required this.isCompleted,
    this.completedModuleIds = const [],
  });
}
