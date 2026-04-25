import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/employee.dart';
import '../../data/models/training.dart';
import '../../data/models/enrollment.dart';

class ExportService {
  static Future<void> exportToExcel(List<EmployeeModel> employees, List<TrainingModel> trainings, List<EnrollmentModel> enrollments) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Rapport Formations'];

    // Headers
    sheetObject.appendRow([
      TextCellValue('Matricule'),
      TextCellValue('Nom'),
      TextCellValue('Prénom'),
      TextCellValue('Poste'),
      TextCellValue('Formation'),
      TextCellValue('Statut'),
    ]);

    for (var enrollment in enrollments) {
      final employee = employees.firstWhere((e) => e.id == enrollment.employeeId);
      final training = trainings.firstWhere((t) => t.id == enrollment.trainingId);

      sheetObject.appendRow([
        TextCellValue(employee.matricule),
        TextCellValue(employee.lastName),
        TextCellValue(employee.firstName),
        TextCellValue(employee.poste),
        TextCellValue(training.title),
        TextCellValue(enrollment.isCompleted ? 'Complété' : 'En cours'),
      ]);
    }

    final fileBytes = excel.save();
    if (fileBytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/rapport_formations_ocp.xlsx');
      await file.writeAsBytes(fileBytes);
    }
  }

  static Future<void> exportToPdf(List<EmployeeModel> employees, List<TrainingModel> trainings, List<EnrollmentModel> enrollments) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('OCP - Rapport de Formation', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24, color: PdfColors.green)),
                  pw.Text(DateTime.now().toString().split(' ')[0]),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Matricule', 'Employé', 'Poste', 'Formation', 'Statut'],
              data: enrollments.map((enr) {
                final emp = employees.firstWhere((e) => e.id == enr.employeeId);
                final tr = trainings.firstWhere((t) => t.id == enr.trainingId);
                return [
                  emp.matricule,
                  '${emp.lastName} ${emp.firstName}',
                  emp.poste,
                  tr.title,
                  enr.isCompleted ? 'Complété' : 'En cours',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.center,
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
