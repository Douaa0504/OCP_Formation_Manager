import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'OCP Formation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            _buildRoleButton(
              context,
              'Espace Employé',
              Icons.person,
              () => Navigator.pushNamed(context, '/login', arguments: AppConstants.roleEmployee),
            ),
            const SizedBox(height: 16),
            _buildRoleButton(
              context,
              'Espace RH',
              Icons.admin_panel_settings,
              () => Navigator.pushNamed(context, '/login', arguments: AppConstants.roleHR),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
