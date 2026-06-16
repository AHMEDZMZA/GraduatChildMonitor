import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:child_monitor_app/features/chat/domain/entities/chat_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(const ChatInitial());

  Future<void> sendMessage(String message, {String? conversationId}) async {
    emit(const ChatSendingMessage());

    final result = await repository.sendMessage(
      message,
      conversationId: conversationId,
    );

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (chatMessage) {
        final currentState = state;
        if (currentState is ChatSuccess) {
          // Append new messages to the existing list to avoid redundant loading state
          final updatedMessages = List<ChatMessage>.from(currentState.messages)
            ..add(chatMessage);
          emit(ChatSuccess(
            messages: updatedMessages,
            conversationId: chatMessage.conversationId ?? currentState.conversationId,
          ));
        } else {
          emit(ChatMessageSent(chatMessage));
        }
      },
    );
  }

  Future<void> getChatHistory({String? conversationId}) async {
    emit(const ChatLoading());

    final result = await repository.getChatHistory(
      conversationId: conversationId,
    );

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (messages) {
        emit(ChatSuccess(messages: messages, conversationId: conversationId));
      },
    );
  }
}
