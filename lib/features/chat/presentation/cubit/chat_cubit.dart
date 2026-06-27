import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:child_monitor_app/features/chat/domain/entities/chat_message.dart';
import 'package:translator/translator.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final translator = GoogleTranslator();

  ChatCubit({required this.repository}) : super(const ChatInitial());

  Future<void> sendMessage(String message, {String? conversationId}) async {
    emit(const ChatSendingMessage());

    String translatedUserMsg = message;
    bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);

    if (isArabic) {
      try {
        final translation = await translator.translate(message, from: 'ar', to: 'en');
        translatedUserMsg = translation.text;
      } catch (_) {}
    }

    final result = await repository.sendMessage(
      translatedUserMsg,
      conversationId: conversationId,
    );

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (chatMessage) async {
        if (isArabic && chatMessage.botReply != null && chatMessage.botReply!.isNotEmpty) {
           try {
             final translation = await translator.translate(chatMessage.botReply!, from: 'en', to: 'ar');
             final updatedMessage = ChatMessage(
               id: chatMessage.id,
               text: chatMessage.text, // note: backend returns English here, but UI only uses botReply
               sender: chatMessage.sender,
               timestamp: chatMessage.timestamp,
               conversationId: chatMessage.conversationId,
               botReply: translation.text,
             );
             _emitSuccess(updatedMessage);
             return;
           } catch (_) {}
        }
        
        _emitSuccess(chatMessage);
      },
    );
  }

  void _emitSuccess(ChatMessage chatMessage) {
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
