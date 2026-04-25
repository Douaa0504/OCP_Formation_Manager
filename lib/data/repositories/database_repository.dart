import '../datasources/local/hive_database.dart';
import '../models/enrollment.dart';
import '../models/attendance.dart';

class DatabaseRepository {
  final HiveDatabase _database = HiveDatabase();

  List<EnrollmentModel> getEnrollmentsByEmployee(String employeeId) {
    return _database.getEnrollmentsByEmployee(employeeId);
  }

  Future<void> addEnrollment(EnrollmentModel enrollment) async {
    await _database.addEnrollment(enrollment);
  }

  List<AttendanceModel> getAttendanceByEmployeeAndModule(String employeeId, String moduleId) {
    return _database.getAttendanceByEmployeeAndModule(employeeId, moduleId);
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    await _database.addAttendance(attendance);
  }
}
