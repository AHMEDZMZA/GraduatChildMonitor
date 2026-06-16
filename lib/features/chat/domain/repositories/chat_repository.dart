import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatMessage>> sendMessage(
    String message, {
    String? conversationId,
  });

  Future<Either<Failure, List<ChatMessage>>> getChatHistory({
    String? conversationId,
  });
}
