import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hr_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/employee.dart';
import '../../../data/models/training.dart';
import '../../../data/models/attendance.dart';
import '../../widgets/custom_card.dart';
import '../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final String employeeId;
  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final hrProvider = context.watch<HRProvider>();
    final authProvider = context.read<AuthProvider>();
    
    EmployeeModel? employee;
    try {
      employee = hrProvider.employees.firstWhere((e) => e.id == widget.employeeId);
    } catch (e) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text("Employé introuvable")));
    }

    final enrollments = hrProvider.getEmployeeEnrollments(widget.employeeId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.firstName} ${employee.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () => _showSendMessageDialog(context, hrProvider, authProvider.currentUser?.id ?? 'hr_0', employee!),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmployeeHeader(employee),
            const SizedBox(height: 24),
            _buildInfoDetails(employee),
            const SizedBox(height: 24),
            const Text('Formations assignées', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (enrollments.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Aucune formation active'),
              ))
            else
              ...enrollments.map((enrollment) {
                final training = hrProvider.trainings.firstWhere(
                  (t) => t.id == enrollment.trainingId, 
                  orElse: () => TrainingModel(id: '', title: 'Inconnu', description: '', duration: '', target: '', linkedPoste: '', modules: [])
                );
                return _buildTrainingProgressCard(context, hrProvider, training, enrollment);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeHeader(EmployeeModel employee) {
    return CustomCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppConstants.softColor,
            child: Text(
              '${employee.firstName[0]}${employee.lastName[0]}'.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${employee.firstName} ${employee.lastName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(employee.poste, style: TextStyle(color: Colors.grey[600])),
                Text(employee.department, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('Matricule: ${employee.matricule}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDetails(EmployeeModel employee) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, 'Email', employee.email),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Téléphone', employee.phone ?? 'N/A'),
            const Divider(),
            _buildInfoRow(Icons.work_history, 'Expérience', '${employee.experienceYears} ans'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.primaryColor),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTrainingProgressCard(BuildContext context, HRProvider hrProvider, TrainingModel training, dynamic enrollment) {
    return CustomCard(
      child: ExpansionTile(
        title: Text(training.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('${enrollment.completedModuleIds.length} / ${training.modules.length} modules complétés'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
              onPressed: () => hrProvider.generateEmployeePDF(hrProvider.employees.firstWhere((e) => e.id == widget.employeeId), training),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: training.modules.map((module) {
          final isCompleted = enrollment.completedModuleIds.contains(module.id);
          final attendances = hrProvider.getAttendanceByModule(widget.employeeId, module.id);

          return ListTile(
            title: Text(module.title),
            subtitle: attendances.isEmpty 
              ? const Text('Aucune présence marquée')
              : Text('${attendances.length} date(s) : ${attendances.map((a) => DateFormat('dd/MM').format(a.date)).join(', ')}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_month, color: attendances.isNotEmpty ? AppConstants.primaryColor : Colors.grey),
                  onPressed: () => _showMultipleAttendanceDialog(context, hrProvider, module.id, attendances),
                ),
                Checkbox(
                  value: isCompleted,
                  activeColor: AppConstants.primaryColor,
                  onChanged: (val) {
                    hrProvider.toggleModuleCompletion(widget.employeeId, training.id, module.id);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showMultipleAttendanceDialog(BuildContext context, HRProvider hrProvider, String moduleId, List<AttendanceModel> currentAttendances) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Gérer les présences'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentAttendances.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Aucune date enregistrée'),
                  ),
                ...currentAttendances.map((att) => ListTile(
                  title: Text(DateFormat('dd/MM/yyyy').format(att.date)),
                  subtitle: Text(att.status == 'Present' ? 'Présent' : 'Absent'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await hrProvider.deleteAttendance(att.id);
                      setState(() {
                        currentAttendances.remove(att);
                      });
                    },
                  ),
                )),
                const Divider(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && context.mounted) {
                      _showStatusSelectionDialog(context, hrProvider, moduleId, picked, (newAtt) {
                        setState(() {
                          currentAttendances.add(newAtt);
                        });
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
          ],
        ),
      ),
    );
  }

  void _showStatusSelectionDialog(BuildContext context, HRProvider hrProvider, String moduleId, DateTime date, Function(AttendanceModel) onAdded) {
    String selectedStatus = 'Present';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Statut pour le ${DateFormat('dd/MM/yyyy').format(date)}'),
          content: DropdownButtonFormField<String>(
            value: selectedStatus,
            items: const [
              DropdownMenuItem(value: 'Present', child: Text('Présent')),
              DropdownMenuItem(value: 'Absent', child: Text('Absent')),
            ],
            onChanged: (val) => setState(() => selectedStatus = val!),
            decoration: const InputDecoration(labelText: 'Statut'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                final newId = 'att_${widget.employeeId}_${moduleId}_${date.millisecondsSinceEpoch}';
                final newAtt = AttendanceModel(
                  id: newId,
                  employeeId: widget.employeeId,
                  moduleId: moduleId,
                  date: date,
                  status: selectedStatus,
                );
                await hrProvider.markAttendance(
                  employeeId: widget.employeeId,
                  moduleId: moduleId,
                  date: date,
                  status: selectedStatus,
                );
                onAdded(newAtt);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendMessageDialog(BuildContext context, HRProvider hrProvider, String senderId, EmployeeModel employee) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedType = 'info';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Message à ${employee.firstName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'info', child: Text('Information')),
                    DropdownMenuItem(value: 'attendance', child: Text('Présence')),
                    DropdownMenuItem(value: 'deadline', child: Text('Date limite')),
                  ],
                  onChanged: (val) => setState(() => selectedType = val!),
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Sujet')),
                TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Contenu'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                hrProvider.sendMessage(
                  senderId: senderId,
                  receiverId: employee.id,
                  title: titleController.text,
                  content: contentController.text,
                  type: selectedType,
                );
                Navigator.pop(context);
              },
              child: const Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAssignTrainingDialog(BuildContext context, HRProvider hrProvider, EmployeeModel employee) {
    // Requirements say HR cannot select training for employee anymore, but keeping it for now or removing if strictly forbidden.
    // Fixed: The requirement says "HR CANNOT: Select training for employee". So I should remove this button.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("L'employé doit choisir sa formation lui-même.")));
  }
}
