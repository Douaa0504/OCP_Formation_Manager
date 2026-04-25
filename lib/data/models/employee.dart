import 'package:hive/hive.dart';
import '../../domain/entities/employee_entity.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String matricule;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String? phone;

  @HiveField(6)
  final String department;

  @HiveField(7)
  final String poste;

  @HiveField(8)
  final int experienceYears;

  @HiveField(9)
  final String password;

  @HiveField(10)
  final String role;

  EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.matricule,
    required this.email,
    this.phone,
    required this.department,
    required this.poste,
    required this.experienceYears,
    required this.password,
    required this.role,
  });

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      matricule: entity.matricule,
      email: entity.email,
      phone: entity.phone,
      department: entity.department,
      poste: entity.poste,
      experienceYears: entity.experienceYears,
      password: entity.password,
      role: entity.role,
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      matricule: matricule,
      email: email,
      phone: phone,
      department: department,
      poste: poste,
      experienceYears: experienceYears,
      password: password,
      role: role,
    );
  }
}
