
// ignore_for_file: use_super_parameters

import 'package:chatshare/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {

  ConversationModel({
    required id,
    required participantName,
    required participantImage,
    required lastMessage,
    required lastMessageTime,
  }) : super(
    id: id,
    participantName: participantName,
    participantImage: participantImage,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime
  );

  factory ConversationModel.fromJson(Map<String, dynamic> json){
    return ConversationModel(
        id: json['conversation_id'],
        participantName: json['participant_name'],
        participantImage: json['participant_image'] ?? 'https://via.placeholder.com/150',
        lastMessage: json['last_message'] ?? '',
        lastMessageTime: json['last_message_time'] != null ? DateTime.parse(json['last_message_time']) : DateTime.now()
    );
  }
}