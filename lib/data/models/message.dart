import 'package:hive/hive.dart';
import '../../domain/entities/message_entity.dart';

part 'message.g.dart';

@HiveType(typeId: 5)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String receiverId;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final DateTime timestamp;
  @HiveField(6)
  final bool isRead;
  @HiveField(7)
  final String type;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      type: entity.type,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      title: title,
      content: content,
      timestamp: timestamp,
      isRead: isRead,
      type: type,
    );
  }
}
