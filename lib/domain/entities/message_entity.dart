class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String title;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'deadline', 'attendance', 'reminder', 'info'

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}
