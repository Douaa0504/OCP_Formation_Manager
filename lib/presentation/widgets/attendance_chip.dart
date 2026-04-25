import 'package:flutter/material.dart';

class AttendanceChip extends StatelessWidget {
  final bool isPresent;

  const AttendanceChip({
    super.key,
    this.isPresent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(isPresent ? 'Présent' : 'Absent'),
      backgroundColor: isPresent ? Colors.green.shade100 : Colors.red.shade100,
      labelStyle: TextStyle(color: isPresent ? Colors.green.shade800 : Colors.red.shade800),
    );
  }
}
