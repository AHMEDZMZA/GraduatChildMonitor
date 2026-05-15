import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/chat/domain/repositories/chat_repository.dart';
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
        emit(ChatError(failure.toString()));
      },
      (chatMessage) {
        emit(ChatMessageSent(chatMessage));
        // Fetch updated history
        getChatHistory(conversationId: chatMessage.conversationId);
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
        emit(ChatError(failure.toString()));
      },
      (messages) {
        emit(ChatSuccess(messages: messages, conversationId: conversationId));
      },
    );
  }
}
