import 'package:flutter/material.dart';
import '../../data/models/attendance.dart';
import '../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class ModuleTile extends StatelessWidget {
  final String title;
  final String description;
  final int order;
  final bool isCompleted;
  final List<AttendanceModel> attendances;

  const ModuleTile({
    super.key,
    required this.title,
    required this.description,
    required this.order,
    this.isCompleted = false,
    this.attendances = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isCompleted ? AppConstants.primaryColor : Colors.grey[200],
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text('$order', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? AppConstants.primaryColor : Colors.black87,
                ),
              ),
            ),
            if (attendances.isNotEmpty)
              _buildAttendanceSummaryBadge(),
          ],
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
        if (attendances.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text('Calendrier de présence :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attendances.map((a) => _buildAttendanceChip(a)).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttendanceSummaryBadge() {
    final presentCount = attendances.where((a) => a.status == 'Present').length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$presentCount Présence(s)',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
      ),
    );
  }

  Widget _buildAttendanceChip(AttendanceModel attendance) {
    final isPresent = attendance.status == 'Present';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isPresent ? AppConstants.primaryColor : AppConstants.errorColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (isPresent ? AppConstants.primaryColor : AppConstants.errorColor).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isPresent ? AppConstants.primaryColor : AppConstants.errorColor,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('dd/MM').format(attendance.date),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isPresent ? AppConstants.primaryColor : AppConstants.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
