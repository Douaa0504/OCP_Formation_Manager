import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hr_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_card.dart';
import 'employee_list_screen.dart';
import 'training_management_screen.dart';
import 'deadline_management_screen.dart';
import '../../../core/constants/app_constants.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HRProvider>().loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hrProvider = context.watch<HRProvider>();
    final authProvider = context.watch<AuthProvider>();

    final totalEmployees = hrProvider.employees.length;
    final totalTrainings = hrProvider.trainings.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord RH'),
        actions: [
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
        onRefresh: () => hrProvider.loadData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppConstants.primaryColor,
                      child: Text('RH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenue, ${authProvider.currentUser?.firstName ?? 'Admin'}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text('Gestionnaire des Formations'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Employés', '$totalEmployees', Icons.people, Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Formations', '$totalTrainings', Icons.school, AppConstants.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Actions de Gestion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildMenuAction(
                context,
                'Liste des Employés',
                'Suivi individuel et assiduité',
                Icons.person_search,
                Colors.blue,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeListScreen())),
              ),
              _buildMenuAction(
                context,
                'Catalogue des Formations',
                'Ajouter, modifier ou supprimer',
                Icons.library_books,
                AppConstants.primaryColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainingManagementScreen())),
              ),
              _buildMenuAction(
                context,
                'Délais & Calendrier',
                'Gérer les dates limites de sélection',
                Icons.event_available,
                Colors.orange,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeadlineManagementScreen())),
              ),
              const SizedBox(height: 24),
              const Text('Rapports & Exports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _exportData(context, hrProvider, 'excel'),
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Export Excel Global'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '* L\'export Excel contient tous les employés, leurs formations et leur assiduité détaillée par module.',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuAction(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _exportData(BuildContext context, HRProvider hrProvider, String type) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String? result;
    if (type == 'excel') {
      result = await hrProvider.exportFullDataToExcel();
    }

    if (context.mounted) {
      Navigator.pop(context);
      
      if (result == "EMPTY") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun employé trouvé pour l\'export.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fichier Excel généré avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la génération du fichier'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
