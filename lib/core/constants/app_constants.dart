import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'OCP Formation Manager';
  
  static const String employeesBox = 'employees';
  static const String trainingsBox = 'trainings';
  static const String enrollmentsBox = 'enrollments';
  static const String attendanceBox = 'attendance';
  static const String messagesBox = 'messages';
  static const String deadlineBox = 'deadline';

  static const String roleHR = 'hr';
  static const String roleEmployee = 'employee';

  static const Color primaryColor = Color(0xFF0A8F3D); // OCP Green
  static const Color secondaryColor = Color(0xFF1B5E20);
  static const Color softColor = Color(0xFFE8F5E9);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFD32F2F);

  static const String deadlinePassedMessage = 'La date limite de sélection est dépassée. Vous ne pouvez plus modifier votre choix.';
}
