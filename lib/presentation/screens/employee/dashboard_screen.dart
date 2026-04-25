import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/training_provider.dart';
import '../../widgets/custom_card.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import 'profile_screen.dart';
import 'training_list_screen.dart';
import 'messages_screen.dart';
import 'training_details_screen.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final trainingProvider = context.read<TrainingProvider>();
      if (authProvider.currentUser != null) {
        trainingProvider.loadTrainings(authProvider.currentUser!.poste, authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final trainingProvider = context.watch<TrainingProvider>();
    final user = authProvider.currentUser;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final selectedTraining = trainingProvider.selectedTraining;
    final isDeadlinePassed = trainingProvider.isDeadlinePassed;
    final unreadMessages = trainingProvider.getUnreadMessageCount(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Dashboard'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesScreen()),
                ),
              ),
              if (unreadMessages > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$unreadMessages',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => trainingProvider.loadTrainings(user.poste, user.id),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppConstants.softColor,
                      child: Text(
                        '${user.firstName[0]}${user.lastName[0]}'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(user.poste, style: TextStyle(color: Colors.grey[700])),
                          Text('Matricule: ${user.matricule}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      ),
                      icon: const Icon(Icons.settings_outlined, color: AppConstants.primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Statut de sélection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              CustomCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: isDeadlinePassed ? AppConstants.errorColor : AppConstants.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date limite', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            trainingProvider.deadline != null
                                ? Helpers.formatDate(trainingProvider.deadline!)
                                : 'Non définie',
                            style: TextStyle(color: isDeadlinePassed ? AppConstants.errorColor : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    if (isDeadlinePassed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                        child: const Text('CLOS', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Ma Formation Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (selectedTraining != null) ...[
                CustomCard(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.school, color: AppConstants.primaryColor, size: 40),
                        title: Text(selectedTraining.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${selectedTraining.modules.length} modules • ${selectedTraining.duration}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingDetailsScreen(training: selectedTraining),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      // Progress simplified for dashboard
                      const LinearProgressIndicator(
                        value: 0.4, // Mock static for dashboard fast view
                        backgroundColor: AppConstants.softColor,
                        valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                        minHeight: 6,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                CustomCard(
                  child: Column(
                    children: [
                      const Icon(Icons.search, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('Aucune formation sélectionnée', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingListScreen(userPoste: user.poste),
                            ),
                          );
                        },
                        child: const Text('Parcourir le catalogue'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Text('Ressources OCP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                   _buildQuickAction(Icons.book, 'Guide', Colors.blue),
                   _buildQuickAction(Icons.help_outline, 'Support', Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
