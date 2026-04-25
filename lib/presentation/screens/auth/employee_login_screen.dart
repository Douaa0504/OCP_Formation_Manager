import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../../core/utils/validators.dart';
import '../employee/dashboard_screen.dart';
import 'register_screen.dart';
import '../../../core/constants/app_constants.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  State<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion Employé'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.person,
                      size: 80,
                      color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bienvenue',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connectez-vous à votre compte',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      validator: Validators.validatePassword,
                      label: 'Mot de passe',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 20),
                    if (authProvider.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppConstants.errorColor),
                        ),
                        child: Text(
                          authProvider.error!,
                          style: const TextStyle(color: AppConstants.errorColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Se connecter',
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await authProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                          if (success && context.mounted) {
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmployeeDashboardScreen(),
                              ),
                            );
                          }
                        }
                      },
                      isLoading: authProvider.isLoading,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Pas de compte ? S\'inscrire'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
