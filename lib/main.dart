import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/hive_database.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/training_provider.dart';
import 'presentation/providers/employee_provider.dart';
import 'presentation/providers/hr_provider.dart';
import 'presentation/screens/auth/role_selection_screen.dart';
import 'presentation/screens/auth/employee_login_screen.dart';
import 'presentation/screens/auth/hr_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = HiveDatabase();
  await db.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => HRProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/role-selection',
        routes: {
          '/role-selection': (context) => const RoleSelectionScreen(),
          '/login': (context) {
            final role = ModalRoute.of(context)!.settings.arguments as String?;
            if (role == AppConstants.roleHR) {
              return const HrLoginScreen();
            }
            return const EmployeeLoginScreen();
          },
        },
      ),
    );
  }
}
