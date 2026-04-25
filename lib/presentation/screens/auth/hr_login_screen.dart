import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hr_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../../core/utils/validators.dart';
import '../hr/hr_dashboard_screen.dart';

class HrLoginScreen extends StatefulWidget {
  const HrLoginScreen({super.key});

  @override
  State<HrLoginScreen> createState() => _HrLoginScreenState();
}

class _HrLoginScreenState extends State<HrLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion RH'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.admin_panel_settings, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Espace RH',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  label: 'Email RH',
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
                  Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Accéder au tableau de bord',
                  isLoading: authProvider.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await authProvider.login(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                      if (success && context.mounted) {
                        if (authProvider.isHR) {
                          if (context.mounted) {
                            context.read<HRProvider>().loadData();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HrDashboardScreen()),
                            );
                          }
                        } else {
                          authProvider.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Accès réservé aux RH')),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
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
