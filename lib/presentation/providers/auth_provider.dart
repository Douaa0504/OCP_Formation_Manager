import 'package:flutter/material.dart';
import '../../data/models/employee.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCases _authUseCases = AuthUseCases();

  EmployeeModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  EmployeeModel? get currentUser => _currentUser;
  set currentUser(EmployeeModel? user) {
    _currentUser = user;
    notifyListeners();
  }
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isHR => _currentUser?.role == 'hr';
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authUseCases.employeeLogin(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Email ou mot de passe incorrect';
      }
    } catch (e) {
      _error = 'Erreur de connexion';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> register(EmployeeModel employee) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authUseCases.registerEmployee(employee.toEntity());
      _error = 'Inscription réussie';
    } catch (e) {
      _error = 'Erreur lors de l\'inscription';
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
