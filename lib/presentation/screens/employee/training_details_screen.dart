import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/training.dart';
import '../../providers/training_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/module_tile.dart';
import '../../../core/constants/app_constants.dart';

class TrainingDetailsScreen extends StatelessWidget {
  final TrainingModel training;
  const TrainingDetailsScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = context.watch<TrainingProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final enrollment = trainingProvider.getEnrollment(user.id, training.id);
    final isEnrolled = enrollment != null;
    final isDeadlinePassed = trainingProvider.isDeadlinePassed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Formation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: AppConstants.primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              training.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cible: ${training.target}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  Text(
                    training.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoIcon(Icons.timer_outlined, training.duration),
                      const SizedBox(width: 20),
                      _buildInfoIcon(Icons.calendar_month_outlined, 
                        training.deadlineDate != null 
                        ? 'Limite: ${training.deadlineDate!.day}/${training.deadlineDate!.month}' 
                        : 'Pas de limite'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Programme de la formation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...training.modules.map((module) {
              final attendances = trainingProvider.getModuleAttendances(user.id, module.id);
              final isCompleted = enrollment?.completedModuleIds.contains(module.id) ?? false;

              return CustomCard(
                child: ModuleTile(
                  title: module.title,
                  description: module.description,
                  order: module.order,
                  isCompleted: isCompleted,
                  attendances: attendances,
                ),
              );
            }),
            const SizedBox(height: 32),
            if (!isEnrolled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isDeadlinePassed ? null : () {
                    trainingProvider.selectTraining(user.id, training.id);
                  },
                  icon: const Icon(Icons.add_task),
                  label: Text(isDeadlinePassed
                      ? 'Date limite dépassée'
                      : 'S\'inscrire à cette formation'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppConstants.primaryColor),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
