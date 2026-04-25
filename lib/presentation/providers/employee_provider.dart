import 'package:flutter/material.dart';
import '../../data/models/employee.dart';
import '../../data/repositories/employee_repository.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();
  List<EmployeeModel> _employees = [];
  EmployeeModel? _selectedEmployee;
  bool _isLoading = false;

  List<EmployeeModel> get employees => _employees;
  EmployeeModel? get selectedEmployee => _selectedEmployee;
  bool get isLoading => _isLoading;

  Future<void> loadAllEmployees() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _employees = _repository.getAllEmployees();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }
}
