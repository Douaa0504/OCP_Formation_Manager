import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/training_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/module_tile.dart';
import '../../../data/models/training.dart';
import '../../../core/constants/app_constants.dart';

class ModulesProgressScreen extends StatelessWidget {
  final TrainingModel training;
  final String employeeId;
  const ModulesProgressScreen({
    super.key,
    required this.training,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    final trainingProvider = context.watch<TrainingProvider>();

    int completedModules = 0;
    for (var module in training.modules) {
      final moduleAttendances = trainingProvider.getModuleAttendances(
        employeeId,
        module.id,
      );
      if (moduleAttendances.isNotEmpty && moduleAttendances.first.isPresent) {
        completedModules++;
      }
    }

    final progress = training.modules.isNotEmpty
        ? (completedModules / training.modules.length)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${training.title} - Progression'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Votre progression',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.secondaryColor),
                      minHeight: 12,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedModules/${training.modules.length} modules',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Icon(Icons.list_alt, color: AppConstants.primaryColor),
                SizedBox(width: 12),
                Text(
                  'Modules',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...training.modules.map((module) {
              final moduleAttendances = trainingProvider.getModuleAttendances(
                employeeId,
                module.id,
              );
              final isCompleted = moduleAttendances.isNotEmpty && moduleAttendances.first.isPresent;

              return CustomCard(
                child: ModuleTile(
                  title: module.title,
                  description: module.description,
                  order: module.order,
                  isCompleted: isCompleted,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
