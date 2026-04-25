import 'package:flutter/material.dart';
import '../../data/models/training.dart';
import '../../data/models/employee.dart';
import '../../data/models/attendance.dart';
import '../../data/models/enrollment.dart';
import '../../data/models/message.dart';
import '../../data/repositories/training_repository.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/datasources/local/hive_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HRProvider with ChangeNotifier {
  final TrainingRepository _trainingRepo = TrainingRepository();
  final EmployeeRepository _employeeRepo = EmployeeRepository();
  final HiveDatabase _db = HiveDatabase();

  List<TrainingModel> _trainings = [];
  List<EmployeeModel> _employees = [];
  bool _isLoading = false;

  List<TrainingModel> get trainings => _trainings;
  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trainings = _trainingRepo.getAllTrainings();
      _employees = _employeeRepo.getAllEmployees();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Employee Management
  Future<void> addEmployee(EmployeeModel employee) async {
    await _db.addEmployee(employee);
    await loadData();
  }

  Future<void> deleteEmployee(String id) async {
    await _db.deleteEmployee(id);
    await loadData();
  }

  // Training Assignment
  Future<void> assignTraining(String employeeId, String trainingId) async {
    final enrollment = EnrollmentModel(
      id: 'enr_${employeeId}_$trainingId',
      employeeId: employeeId,
      trainingId: trainingId,
      enrollmentDate: DateTime.now(),
      progress: 0.0,
      isCompleted: false,
      completedModuleIds: [],
    );
    await _db.addEnrollment(enrollment);
    notifyListeners();
  }

  // Training Management
  Future<void> addTraining(TrainingModel training) async {
    await _db.addTraining(training);
    await loadData();
  }

  Future<void> updateTraining(TrainingModel training) async {
    await _db.updateTraining(training);
    await loadData();
  }

  Future<void> deleteTraining(String id) async {
    await _db.deleteTraining(id);
    await loadData();
  }

  // Attendance Management
  List<AttendanceModel> getEmployeeAttendance(String employeeId) {
    return _db.getAttendanceByEmployee(employeeId);
  }

  List<AttendanceModel> getAttendanceByModule(String employeeId, String moduleId) {
    return _db.getAttendanceByEmployeeAndModule(employeeId, moduleId);
  }

  List<EnrollmentModel> getEmployeeEnrollments(String employeeId) {
    return _db.getEnrollmentsByEmployee(employeeId);
  }

  Future<void> markAttendance({
    required String employeeId,
    required String moduleId,
    required DateTime date,
    required String status,
  }) async {
    final attendance = AttendanceModel(
      id: 'att_${employeeId}_${moduleId}_${date.millisecondsSinceEpoch}',
      employeeId: employeeId,
      moduleId: moduleId,
      date: date,
      status: status,
    );
    await _db.addAttendance(attendance);
    notifyListeners();
  }

  Future<void> deleteAttendance(String attendanceId) async {
    await _db.deleteAttendance(attendanceId);
    notifyListeners();
  }

  Future<void> toggleModuleCompletion(String employeeId, String trainingId, String moduleId) async {
    final enrollment = _db.getEnrollment(employeeId, trainingId);
    if (enrollment == null) return;

    final updatedModules = List<String>.from(enrollment.completedModuleIds);
    if (updatedModules.contains(moduleId)) {
      updatedModules.remove(moduleId);
    } else {
      updatedModules.add(moduleId);
    }

    final training = _db.getTrainingById(trainingId);
    final progress = training != null && training.modules.isNotEmpty 
        ? updatedModules.length / training.modules.length 
        : 0.0;

    final updatedEnrollment = EnrollmentModel(
      id: enrollment.id,
      employeeId: employeeId,
      trainingId: trainingId,
      enrollmentDate: enrollment.enrollmentDate,
      progress: progress,
      isCompleted: progress == 1.0,
      completedModuleIds: updatedModules,
    );

    await _db.updateEnrollment(updatedEnrollment);
    notifyListeners();
  }

  // PDF Export (Per Employee)
  Future<void> generateEmployeePDF(EmployeeModel employee, TrainingModel training) async {
    try {
      final pdf = pw.Document();
      final allAttendances = _db.getAttendanceByEmployee(employee.id);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(level: 0, child: pw.Text('Fiche de Suivi de Formation - OCP', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18))),
              pw.SizedBox(height: 20),
              pw.Text('Employé: ${employee.firstName} ${employee.lastName}'),
              pw.Text('Matricule: ${employee.matricule}'),
              pw.Text('Poste: ${employee.poste}'),
              pw.SizedBox(height: 10),
              pw.Text('Formation: ${training.title}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Module', 'Dates de présence', 'Statut'],
                data: training.modules.map((m) {
                  final moduleAttendances = allAttendances.where((a) => a.moduleId == m.id).toList();
                  final datesStr = moduleAttendances.isEmpty 
                    ? '-' 
                    : moduleAttendances.map((a) => '${DateFormat('dd/MM').format(a.date)} (${a.status == 'Present' ? 'P' : 'A'})').join(', ');
                  
                  final isComp = _db.getEnrollment(employee.id, training.id)?.completedModuleIds.contains(m.id) ?? false;

                  return [
                    m.title,
                    datesStr,
                    isComp ? 'Complété' : 'En cours',
                  ];
                }).toList(),
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      debugPrint("PDF Export Error: $e");
    }
  }

  // Excel Export (Full Project Data - All Employees)
  Future<String?> exportFullDataToExcel() async {
    try {
      final allEmployees = _db.getAllEmployees();
      debugPrint("Employees count: ${allEmployees.length}");
      
      if (allEmployees.isEmpty) {
        return "EMPTY";
      }

      var excel = Excel.createExcel();
      // Remove default sheet if possible or just use 'Employees'
      excel.rename('Sheet1', 'Employees');
      Sheet sheet = excel['Employees'];
      
      // Header Row
      sheet.appendRow([
        TextCellValue('Name'),
        TextCellValue('Email'),
        TextCellValue('Phone'),
        TextCellValue('Poste'),
        TextCellValue('Experience'),
        TextCellValue('Training'),
        TextCellValue('Modules'),
        TextCellValue('Completion'),
        TextCellValue('Attendance')
      ]);
      
      final allTrainings = _db.getAllTrainings();
      
      for (var emp in allEmployees) {
        final enrollments = _db.getEnrollmentsByEmployee(emp.id);

        if (enrollments.isEmpty) {
          sheet.appendRow([
            TextCellValue('${emp.firstName} ${emp.lastName}'),
            TextCellValue(emp.email),
            TextCellValue(emp.phone ?? ''),
            TextCellValue(emp.poste),
            TextCellValue(emp.experienceYears.toString()),
            TextCellValue('Aucune'),
            TextCellValue(''),
            TextCellValue(''),
            TextCellValue('')
          ]);
        } else {
          for (var enr in enrollments) {
            final training = allTrainings.firstWhere(
              (t) => t.id == enr.trainingId,
              orElse: () => TrainingModel(id: '', title: '', description: '', duration: '', target: '', linkedPoste: '', modules: [])
            );

            if (training.id.isEmpty) continue;

            for (var module in training.modules) {
              final attendance = _db.getAttendanceByEmployeeAndModule(emp.id, module.id);
              final isCompleted = enr.completedModuleIds.contains(module.id);

              sheet.appendRow([
                TextCellValue('${emp.firstName} ${emp.lastName}'),
                TextCellValue(emp.email),
                TextCellValue(emp.phone ?? ''),
                TextCellValue(emp.poste),
                TextCellValue(emp.experienceYears.toString()),
                TextCellValue(training.title),
                TextCellValue(module.title),
                TextCellValue(isCompleted ? '✔' : '❌'),
                TextCellValue(attendance.isEmpty 
                  ? 'No records' 
                  : attendance.map((a) => "${DateFormat('dd/MM/yyyy').format(a.date)} (${a.status})").join(", "))
              ]);
            }
          }
        }
      }

      debugPrint("Excel rows added");

      final fileBytes = excel.encode();
      if (fileBytes != null) {
        final bytes = Uint8List.fromList(fileBytes);
        if (kIsWeb) {
          await Printing.sharePdf(bytes: bytes, filename: 'rapport_global_formations.xlsx');
          return "SUCCESS";
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final path = '${directory.path}/rapport_global_formations_${DateTime.now().millisecondsSinceEpoch}.xlsx';
          final file = File(path);
          await file.writeAsBytes(bytes);
          debugPrint("Excel saved to: $path");
          return path;
        }
      }
      return null;
    } catch (e) {
      debugPrint("Excel Export Error: $e");
      return null;
    }
  }

  // Messaging
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String title,
    required String content,
    required String type,
  }) async {
    final message = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      title: title,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
      type: type,
    );
    await _db.addMessage(message);
    notifyListeners();
  }

  Future<void> setDeadline(DateTime deadline) async {
    await _db.setDeadline(deadline);
    notifyListeners();
  }
}
