import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/training_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import 'training_details_screen.dart';
import 'modules_progress_screen.dart';

class TrainingListScreen extends StatefulWidget {
  final String userPoste;
  const TrainingListScreen({super.key, required this.userPoste});

  @override
  State<TrainingListScreen> createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        context.read<TrainingProvider>().loadTrainings(widget.userPoste, authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainingProvider = context.watch<TrainingProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser!;
    final selectedTraining = trainingProvider.selectedTraining;
    final isDeadlinePassed = trainingProvider.isDeadlinePassed;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTraining != null
            ? 'Ma formation'
            : 'Choisir une formation'),
      ),
      body: trainingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => trainingProvider.loadTrainings(widget.userPoste, user.id),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (isDeadlinePassed)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppConstants.errorColor),
                ),
                child: const Text(
                  AppConstants.deadlinePassedMessage,
                  style: TextStyle(color: AppConstants.errorColor, fontWeight: FontWeight.bold),
                ),
              ),

            if (selectedTraining != null) ...[
              const Text('Formation sélectionnée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CustomCard(
                child: ListTile(
                  title: Text(selectedTraining.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(selectedTraining.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModulesProgressScreen(
                        training: selectedTraining,
                        employeeId: user.id,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              selectedTraining != null ? 'Autres formations' : 'Formations disponibles',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (trainingProvider.trainings.isEmpty)
              const EmptyState(
                title: 'Aucune formation',
                subtitle: 'Aucune formation pour votre poste',
                icon: Icons.school_outlined,
              )
            else
              ...trainingProvider.trainings.where((t) => t.id != selectedTraining?.id).map((training) =>
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(training.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(training.description),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingDetailsScreen(training: training),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: CustomButton(
                            text: 'Sélectionner',
                            onPressed: isDeadlinePassed ? null : () {
                              trainingProvider.selectTraining(user.id, training.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
          ],
        ),
      ),
    );
  }
}
