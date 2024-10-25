import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderID;
  final String? repliedMessageId; // ID of the replied message
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderID,
    this.repliedMessageId, // Updated constructor
    required this.createdAt,
  });
}
