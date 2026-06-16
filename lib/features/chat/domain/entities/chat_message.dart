class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final String? conversationId;
  final String? botReply;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.conversationId,
    this.botReply,
  });

  bool get isUser => sender == 'user';
  bool get isBot => sender == 'bot';
}
