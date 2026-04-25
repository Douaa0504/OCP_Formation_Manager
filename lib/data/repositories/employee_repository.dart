import '../datasources/local/hive_database.dart';
import '../models/employee.dart';
import '../../domain/entities/employee_entity.dart';
import '../../core/constants/app_constants.dart';

class EmployeeRepository {
  final HiveDatabase _database = HiveDatabase();

  Future<EmployeeModel?> login(String email, String password) async {
    try {
      final employee = _database.getEmployeeByEmail(email);
      if (employee != null && employee.password == password) {
        return employee;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> registerEmployee(EmployeeEntity employee) async {
    final employeeModel = EmployeeModel(
      id: employee.id,
      firstName: employee.firstName,
      lastName: employee.lastName,
      matricule: employee.matricule,
      email: employee.email,
      phone: employee.phone,
      department: employee.department,
      poste: employee.poste,
      experienceYears: employee.experienceYears,
      password: employee.password,
      role: AppConstants.roleEmployee,
    );
    await _database.addEmployee(employeeModel);
  }

  List<EmployeeModel> getAllEmployees() => _database.getAllEmployees();

  Future<void> updateEmployee(EmployeeModel employee) async {
    await _database.updateEmployee(employee);
  }

  EmployeeModel? getEmployeeById(String id) {
    try {
      return _database.employeesBox.get(id);
    } catch (e) {
      return null;
    }
  }
}
