import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/employee.dart';
import '../../../core/constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedPoste;
  int _experienceYears = 0;

  final List<String> departments = [
    'Production', 'Maintenance', 'Qualité', 'Logistique', 'Ressources Humaines'
  ];

  final List<String> postes = ['Opérateur', 'Technicien', 'Superviseur', 'Ingénieur'];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.person_add, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Inscription Employé',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        validator: (value) => Validators.validateRequired(value, 'Prénom'),
                        label: 'Prénom',
                        prefixIcon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        validator: (value) => Validators.validateRequired(value, 'Nom'),
                        label: 'Nom',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _matriculeController,
                  validator: (value) => Validators.validateRequired(value, 'Matricule'),
                  label: 'Matricule',
                  prefixIcon: Icons.badge,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  label: 'Téléphone',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: const InputDecoration(labelText: 'Département'),
                  items: departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                  onChanged: (value) => setState(() => _selectedDepartment = value),
                  validator: (value) => value == null ? 'Veuillez choisir un département' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPoste,
                  decoration: const InputDecoration(labelText: 'Poste'),
                  items: postes.map((post) => DropdownMenuItem(value: post, child: Text(post))).toList(),
                  onChanged: (value) => setState(() => _selectedPoste = value),
                  validator: (value) => value == null ? 'Veuillez choisir un poste' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Années d\'expérience'),
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  onChanged: (value) => _experienceYears = int.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  label: 'Mot de passe',
                  obscureText: true,
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 32),
                if (authProvider.error != null)
                  Text(authProvider.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'S\'inscrire',
                  isLoading: authProvider.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final employee = EmployeeModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        matricule: _matriculeController.text.trim(),
                        email: _emailController.text.trim(),
                        phone: _phoneController.text.trim(),
                        department: _selectedDepartment!,
                        poste: _selectedPoste!,
                        experienceYears: _experienceYears,
                        password: _passwordController.text,
                        role: AppConstants.roleEmployee,
                      );
                      await authProvider.register(employee);
                      if (context.mounted && authProvider.error == 'Inscription réussie') {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _matriculeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
