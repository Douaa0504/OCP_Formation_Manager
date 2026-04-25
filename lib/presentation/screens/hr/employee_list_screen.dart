import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../../data/models/employee.dart';
import 'employee_details_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().loadAllEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = context.watch<EmployeeProvider>();

    List<EmployeeModel> filteredEmployees = employeeProvider.employees.where((employee) {
      final name = '${employee.firstName} ${employee.lastName}'.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || employee.matricule.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des employés'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou matricule...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: filteredEmployees.isEmpty
                ? const EmptyState(
                    title: 'Aucun employé',
                    subtitle: 'Aucun résultat pour votre recherche',
                    icon: Icons.people_outline,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return CustomCard(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(employee.firstName[0].toUpperCase()),
                          ),
                          title: Text('${employee.firstName} ${employee.lastName}'),
                          subtitle: Text('Matricule: ${employee.matricule} - ${employee.poste}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeDetailsScreen(employeeId: employee.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
