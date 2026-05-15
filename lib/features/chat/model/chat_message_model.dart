/// Simple UI model used in ChatView for displaying bubbles
class ChatMessageModel {
  final String text;
  final bool isMe;

  const ChatMessageModel({required this.text, required this.isMe});
}

/// Domain model representing a full chat message with metadata
class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'user' or 'bot'
  final DateTime timestamp;
  final String? conversationId;
  final String? botReply; // Optional bot response text bundled with user message

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
