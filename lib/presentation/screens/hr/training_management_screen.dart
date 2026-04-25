import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hr_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/empty_state.dart';
import '../../../data/models/training.dart';
import '../../../data/models/module.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';

class TrainingManagementScreen extends StatefulWidget {
  const TrainingManagementScreen({super.key});

  @override
  State<TrainingManagementScreen> createState() => _TrainingManagementScreenState();
}

class _TrainingManagementScreenState extends State<TrainingManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _targetController = TextEditingController();
  final _posteController = TextEditingController();
  List<ModuleModel> _modules = [];
  bool _isEditing = false;
  String? _editingTrainingId;

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _durationController.clear();
    _targetController.clear();
    _posteController.clear();
    _modules = [];
    _isEditing = false;
    _editingTrainingId = null;
  }

  void _startEditing(TrainingModel training) {
    setState(() {
      _isEditing = true;
      _editingTrainingId = training.id;
      _titleController.text = training.title;
      _descriptionController.text = training.description;
      _durationController.text = training.duration;
      _targetController.text = training.target;
      _posteController.text = training.linkedPoste;
      _modules = List.from(training.modules);
    });
    _showTrainingDialog();
  }

  void _showTrainingDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_isEditing ? 'Modifier la formation' : 'Nouvelle formation'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: _titleController,
                    label: 'Titre de la formation',
                    validator: (v) => Validators.validateRequired(v, 'Titre'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _posteController,
                    label: 'Poste cible (ex: Opérateur)',
                    validator: (v) => Validators.validateRequired(v, 'Poste'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _durationController,
                    label: 'Durée (ex: 3 jours)',
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Modules', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            _modules.add(ModuleModel(
                              id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                              title: 'Nouveau Module',
                              description: '',
                              order: _modules.length + 1,
                            ));
                          });
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Ajouter'),
                      ),
                    ],
                  ),
                  ..._modules.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(hintText: 'Nom du module', isDense: true),
                              onChanged: (val) => _modules[index] = ModuleModel(
                                id: _modules[index].id,
                                title: val,
                                description: _modules[index].description,
                                order: _modules[index].order,
                              ),
                              controller: TextEditingController(text: _modules[index].title),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              decoration: const InputDecoration(hintText: 'Description', isDense: true),
                              onChanged: (val) => _modules[index] = ModuleModel(
                                id: _modules[index].id,
                                title: _modules[index].title,
                                description: val,
                                order: _modules[index].order,
                              ),
                              controller: TextEditingController(text: _modules[index].description),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => setDialogState(() => _modules.removeAt(index)),
                                child: const Text('Supprimer', style: TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final hrProvider = context.read<HRProvider>();
                  final training = TrainingModel(
                    id: _isEditing ? _editingTrainingId! : 'tr_${DateTime.now().millisecondsSinceEpoch}',
                    title: _titleController.text,
                    description: _descriptionController.text,
                    duration: _durationController.text,
                    target: _targetController.text,
                    linkedPoste: _posteController.text,
                    modules: _modules,
                    deadlineDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (_isEditing) {
                    await hrProvider.updateTraining(training);
                  } else {
                    await hrProvider.addTraining(training);
                  }
                  Navigator.pop(context);
                  _resetForm();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hrProvider = context.watch<HRProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du Catalogue'),
      ),
      body: hrProvider.trainings.isEmpty
          ? const EmptyState(
              title: 'Catalogue vide',
              subtitle: 'Commencez par ajouter une formation pour vos collaborateurs.',
              icon: Icons.library_books_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hrProvider.trainings.length,
              itemBuilder: (context, index) {
                final training = hrProvider.trainings[index];
                return CustomCard(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppConstants.softColor,
                      child: Icon(Icons.school, color: AppConstants.primaryColor),
                    ),
                    title: Text(training.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${training.modules.length} modules • Poste: ${training.linkedPoste}'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                        const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _startEditing(training);
                        } else if (value == 'delete') {
                          _confirmDelete(context, hrProvider, training);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _resetForm();
          _showTrainingDialog();
        },
        label: const Text('Nouvelle Formation'),
        icon: const Icon(Icons.add),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }

  void _confirmDelete(BuildContext context, HRProvider hrProvider, TrainingModel training) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer la formation "${training.title}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              hrProvider.deleteTraining(training.id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
