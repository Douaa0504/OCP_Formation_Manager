import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/employee.dart';
import '../../models/training.dart';
import '../../models/module.dart';
import '../../models/enrollment.dart';
import '../../models/attendance.dart';
import '../../models/message.dart';
import '../../../core/constants/app_constants.dart';
import 'dart:math';

class HiveDatabase {
  static final HiveDatabase _instance = HiveDatabase._internal();
  factory HiveDatabase() => _instance;
  HiveDatabase._internal();

  // Single Source of Truth for Postes
  static const List<String> hrPostes = [
    "HR Assistant",
    "HR Manager",
    "Recruiter",
    "Payroll Specialist",
    "HR Analyst",
    "Training Manager",
    "HRIS Specialist",
    "Talent Manager",
    "Employee Relations Specialist",
    "Learning & Development Specialist"
  ];

  late Box<EmployeeModel> employeesBox;
  late Box<TrainingModel> trainingsBox;
  late Box<EnrollmentModel> enrollmentsBox;
  late Box<AttendanceModel> attendanceBox;
  late Box<MessageModel> messagesBox;
  late Box<DateTime> deadlineBox;

  Future<void> init() async {
    try {
      if (kIsWeb) {
        await Hive.initFlutter();
      } else {
        final dir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(dir.path);
      }
      
      _registerAdapters();

      employeesBox = await Hive.openBox<EmployeeModel>(AppConstants.employeesBox);
      trainingsBox = await Hive.openBox<TrainingModel>(AppConstants.trainingsBox);
      enrollmentsBox = await Hive.openBox<EnrollmentModel>(AppConstants.enrollmentsBox);
      attendanceBox = await Hive.openBox<AttendanceModel>(AppConstants.attendanceBox);
      messagesBox = await Hive.openBox<MessageModel>(AppConstants.messagesBox);
      deadlineBox = await Hive.openBox<DateTime>(AppConstants.deadlineBox);

      if (employeesBox.isEmpty) {
        await _initMockData();
      }
    } catch (e) {
      debugPrint("Hive Initialization Error: $e");
      // Fallback for initialization if something goes wrong
      await Hive.initFlutter();
    }
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(EmployeeModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ModuleModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TrainingModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(AttendanceModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(EnrollmentModelAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(MessageModelAdapter());
  }

  Future<void> _initMockData() async {
    final random = Random();

    // 1. Generate Formations (One per Poste from the official list)
    final List<TrainingModel> allTrainings = [];
    for (int i = 0; i < hrPostes.length; i++) {
      final poste = hrPostes[i];
      final moduleCount = 10 + random.nextInt(6); // 10-15 modules
      final modules = List.generate(
        moduleCount,
        (j) => ModuleModel(
          id: 'm_${poste.replaceAll(' ', '_')}_$j',
          title: 'Module ${j + 1} : Expertise en $poste',
          description: 'Description détaillée du module ${j + 1}.',
          order: j + 1,
        ),
      );

      final training = TrainingModel(
        id: 't_${poste.replaceAll(' ', '_')}',
        title: 'Formation Master $poste',
        description: 'Parcours complet certifiant pour le poste de $poste.',
        duration: '${moduleCount * 4} heures',
        target: poste,
        linkedPoste: poste,
        modules: modules,
        deadlineDate: DateTime.now().add(const Duration(days: 30)),
      );
      await addTraining(training);
      allTrainings.add(training);
    }

    // 2. Generate 10 HR Users (Manager role)
    for (int i = 0; i < 10; i++) {
      await addEmployee(EmployeeModel(
        id: 'hr_$i',
        firstName: 'RH_Admin',
        lastName: '${i + 1}',
        matricule: 'HR${1000 + i}',
        email: 'hr$i@ocp.com',
        phone: '06${10000000 + i}',
        department: 'Ressources Humaines',
        poste: 'HR Manager',
        experienceYears: 5 + i,
        password: 'password123',
        role: AppConstants.roleHR,
      ));
    }

    // 3. Generate 100 Employees (Strictly using the hrPostes list)
    for (int i = 1; i <= 100; i++) {
      final poste = hrPostes[i % hrPostes.length];
      final empId = 'emp_$i';
      final emp = EmployeeModel(
        id: empId,
        firstName: 'Employé',
        lastName: '$i',
        matricule: 'EMP${2000 + i}',
        email: 'user$i@ocp.com',
        phone: '06${20000000 + i}',
        department: 'Direction Opérationnelle',
        poste: poste,
        experienceYears: 1 + random.nextInt(15),
        password: 'password123',
        role: AppConstants.roleEmployee,
      );
      await addEmployee(emp);
    }
    await setDeadline(DateTime.now().add(const Duration(days: 20)));
  }

  // --- Helper Methods ---

  EmployeeModel? getEmployeeByEmail(String email) {
    try {
      return employeesBox.values.firstWhere((e) => e.email == email);
    } catch (_) {
      return null;
    }
  }

  EmployeeModel? getEmployeeById(String id) => employeesBox.get(id);
  List<EmployeeModel> getAllEmployees() => employeesBox.values.toList();
  Future<void> addEmployee(EmployeeModel employee) async => await employeesBox.put(employee.id, employee);
  Future<void> updateEmployee(EmployeeModel employee) async => await employeesBox.put(employee.id, employee);
  Future<void> deleteEmployee(String id) async => await employeesBox.delete(id);

  List<TrainingModel> getAllTrainings() => trainingsBox.values.toList();
  TrainingModel? getTrainingById(String id) => trainingsBox.get(id);
  Future<void> addTraining(TrainingModel training) async => await trainingsBox.put(training.id, training);
  Future<void> updateTraining(TrainingModel training) async => await trainingsBox.put(training.id, training);
  Future<void> deleteTraining(String id) async => await trainingsBox.delete(id);

  List<EnrollmentModel> getEnrollmentsByEmployee(String employeeId) =>
      enrollmentsBox.values.where((e) => e.employeeId == employeeId).toList();

  EnrollmentModel? getEnrollment(String employeeId, String trainingId) {
    try {
      return enrollmentsBox.values.firstWhere((e) => e.employeeId == employeeId && e.trainingId == trainingId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addEnrollment(EnrollmentModel enrollment) async => await enrollmentsBox.put(enrollment.id, enrollment);
  Future<void> updateEnrollment(EnrollmentModel enrollment) async => await enrollmentsBox.put(enrollment.id, enrollment);
  Future<void> deleteEnrollment(String id) async => await enrollmentsBox.delete(id);

  List<AttendanceModel> getAttendanceByEmployee(String employeeId) =>
      attendanceBox.values.where((a) => a.employeeId == employeeId).toList();

  List<AttendanceModel> getAttendanceByEmployeeAndModule(String employeeId, String moduleId) {
    return attendanceBox.values.where((a) => a.employeeId == employeeId && a.moduleId == moduleId).toList();
  }

  Future<void> deleteAttendance(String id) async => await attendanceBox.delete(id);

  Future<void> addAttendance(AttendanceModel attendance) async {
    await attendanceBox.put(attendance.id, attendance);
  }

  List<MessageModel> getMessagesForUser(String userId) {
    final msgs = messagesBox.values.where((m) => m.receiverId == userId).toList();
    msgs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return msgs;
  }

  int getUnreadMessageCount(String userId) => messagesBox.values.where((m) => m.receiverId == userId && !m.isRead).length;

  Future<void> markMessageAsRead(String messageId) async {
    final msg = messagesBox.get(messageId);
    if (msg != null) {
      await messagesBox.put(messageId, MessageModel(
        id: msg.id, senderId: msg.senderId, receiverId: msg.receiverId,
        title: msg.title, content: msg.content, timestamp: msg.timestamp,
        isRead: true, type: msg.type,
      ));
    }
  }

  Future<void> addMessage(MessageModel message) async => await messagesBox.put(message.id, message);

  DateTime? getDeadline() => deadlineBox.get('globalDeadline');
  Future<void> setDeadline(DateTime deadline) async => await deadlineBox.put('globalDeadline', deadline);
}
