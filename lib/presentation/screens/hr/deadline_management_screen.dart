import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/hr_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../../data/repositories/training_repository.dart';

class DeadlineManagementScreen extends StatefulWidget {
  const DeadlineManagementScreen({super.key});

  @override
  State<DeadlineManagementScreen> createState() => _DeadlineManagementScreenState();
}

class _DeadlineManagementScreenState extends State<DeadlineManagementScreen> {
  final TrainingRepository _trainingRepo = TrainingRepository();
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _selectedDeadline = _trainingRepo.getDeadline();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion Date Limite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomCard(
              child: ListTile(
                title: const Text('Date limite actuelle'),
                subtitle: Text(_selectedDeadline != null 
                  ? DateFormat('dd/MM/yyyy').format(_selectedDeadline!) 
                  : 'Non définie'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Enregistrer la date limite',
              onPressed: _selectedDeadline == null ? null : () async {
                final hrProvider = context.read<HRProvider>();
                await hrProvider.setDeadline(_selectedDeadline!);
                
                if (!context.mounted) return;
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Date limite enregistrée')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
