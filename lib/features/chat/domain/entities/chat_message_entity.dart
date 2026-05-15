class ChatMessageEntity {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final String? conversationId;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.conversationId,
  });
}
