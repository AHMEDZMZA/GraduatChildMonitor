import 'package:equatable/equatable.dart';
import '../../model/chat_message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatSuccess extends ChatState {
  final List<ChatMessage> messages;
  final String? conversationId;

  const ChatSuccess({required this.messages, this.conversationId});

  @override
  List<Object?> get props => [messages, conversationId];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatSendingMessage extends ChatState {
  const ChatSendingMessage();
}

class ChatMessageSent extends ChatState {
  final ChatMessage message;

  const ChatMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}
