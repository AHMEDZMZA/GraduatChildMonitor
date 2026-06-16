import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/chat/domain/entities/chat_message.dart';

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
