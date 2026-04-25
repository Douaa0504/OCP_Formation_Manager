class AttendanceEntity {
  final String id;
  final String employeeId;
  final String moduleId;
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Late'
  final String? notes;

  AttendanceEntity({
    required this.id,
    required this.employeeId,
    required this.moduleId,
    required this.date,
    required this.status,
    this.notes,
  });

  bool get isPresent => status.toLowerCase() == 'present';
}
