import '../../data/models/employee.dart';
import '../entities/employee_entity.dart';
import '../../data/repositories/employee_repository.dart';

class AuthUseCases {
  final EmployeeRepository _repository = EmployeeRepository();

  Future<EmployeeModel?> employeeLogin(String email, String password) async {
    return await _repository.login(email, password);
  }

  Future<void> registerEmployee(EmployeeEntity employee) async {
    await _repository.registerEmployee(employee);
  }
}
