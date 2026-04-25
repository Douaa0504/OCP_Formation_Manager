import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static bool isDeadlinePassed(DateTime? deadline) {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
      case 'completed':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
