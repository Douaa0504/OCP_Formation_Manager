import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/datasources/local/hive_database.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _db = HiveDatabase();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final messages = _db.getMessagesForUser(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Messages'),
      ),
      body: messages.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun message pour le moment', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Card(
                  elevation: msg.isRead ? 0 : 2,
                  color: msg.isRead ? Colors.white : AppConstants.softColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTypeColor(msg.type),
                      child: Icon(_getTypeIcon(msg.type), color: Colors.white, size: 20),
                    ),
                    title: Text(
                      msg.title,
                      style: TextStyle(
                        fontWeight: msg.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.content),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(msg.timestamp),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: !msg.isRead
                        ? IconButton(
                            icon: const Icon(Icons.mark_email_read, color: AppConstants.primaryColor),
                            onPressed: () async {
                              await _db.markMessageAsRead(msg.id);
                              if (!mounted) return;
                              setState(() {});
                            },
                          )
                        : null,
                    onTap: () async {
                      if (!msg.isRead) {
                        await _db.markMessageAsRead(msg.id);
                        if (!mounted) return;
                        setState(() {});
                      }
                      if (!mounted) return;
                      _showMessageDetails(context, msg.title, msg.content);
                    },
                  ),
                );
              },
            ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'deadline': return Colors.orange;
      case 'attendance': return Colors.red;
      case 'reminder': return Colors.blue;
      default: return AppConstants.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'deadline': return Icons.timer;
      case 'attendance': return Icons.person_off;
      case 'reminder': return Icons.notifications;
      default: return Icons.info;
    }
  }

  void _showMessageDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
