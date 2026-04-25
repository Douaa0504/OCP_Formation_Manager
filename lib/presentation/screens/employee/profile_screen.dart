import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/employee.dart';
import '../../../data/repositories/employee_repository.dart';
import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeRepository _employeeRepo = EmployeeRepository();
  late EmployeeModel user;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    user = authProvider.currentUser!;
    _phoneController = TextEditingController(text: user.phone ?? '');
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final updatedUser = EmployeeModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        matricule: user.matricule,
        email: user.email,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        department: user.department,
        poste: user.poste,
        experienceYears: user.experienceYears,
        password: user.password,
        role: user.role,
      );

      await _employeeRepo.updateEmployee(updatedUser);

      if (mounted) {
        // Update in provider
        context.read<AuthProvider>().currentUser = updatedUser;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: const BoxDecoration(
                  color: AppConstants.softColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${user.firstName[0]}${user.lastName[0]}'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildInfoField('Nom complet', '${user.firstName} ${user.lastName}'),
              _buildInfoField('Matricule', user.matricule),
              _buildInfoField('Email', user.email),
              CustomTextField(
                controller: _phoneController,
                validator: _isEditing ? Validators.validatePhone : null,
                label: 'Téléphone',
                enabled: _isEditing,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 16),
              _buildInfoField('Département', user.department),
              _buildInfoField('Poste', user.poste),
              _buildInfoField('Expérience', '${user.experienceYears} ans'),
              const SizedBox(height: 40),
              if (!_isEditing)
                CustomButton(
                  text: 'Modifier le profil',
                  backgroundColor: AppConstants.secondaryColor,
                  onPressed: () => setState(() => _isEditing = true),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Annuler',
                        backgroundColor: Colors.grey,
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _phoneController.text = user.phone ?? '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Enregistrer',
                        isLoading: _isSaving,
                        onPressed: _saveProfile,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomTextField(
        initialValue: value,
        label: label,
        enabled: false,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
