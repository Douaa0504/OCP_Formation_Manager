class EmployeeEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String matricule;
  final String email;
  final String? phone;
  final String department;
  final String poste;
  final int experienceYears;
  final String password;
  final String role;

  EmployeeEntity({
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
}
