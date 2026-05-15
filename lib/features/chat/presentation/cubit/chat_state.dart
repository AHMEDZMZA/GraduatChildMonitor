abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatSuccess extends ChatState {
  final List<dynamic> messages;
  final String? conversationId;

  const ChatSuccess({required this.messages, this.conversationId});
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);
}

class ChatSendingMessage extends ChatState {
  const ChatSendingMessage();
}

class ChatMessageSent extends ChatState {
  final dynamic message;

  const ChatMessageSent(this.message);
}
