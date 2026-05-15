import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:child_monitor_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:child_monitor_app/features/chat/model/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(
    String message, {
    String? conversationId,
  }) async {
    try {
      final response = await remoteDataSource.sendMessage(
        message,
        conversationId: conversationId,
      );

      return Right(
        ChatMessage(
          id: response.conversationId,
          text: message,
          sender: 'user',
          timestamp: DateTime.now(),
          conversationId: response.conversationId,
          botReply: response.botResponse.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatHistory({
    String? conversationId,
  }) async {
    try {
      final response = await remoteDataSource.getChatHistory(
        conversationId: conversationId,
      );

      // ChatHistoryResponse.messages is List<ChatMessage> from api_client
      // Each ChatMessage has .message (text) and .timestamp (string)
      final messages = response.messages
          .asMap()
          .entries
          .map(
            (entry) => ChatMessage(
              id: '${conversationId ?? ''}_${entry.key}',
              text: entry.value.message,
              sender: entry.key % 2 == 0 ? 'user' : 'bot',
              timestamp: _parseTimestamp(entry.value.timestamp),
              conversationId: conversationId,
            ),
          )
          .toList();

      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  DateTime _parseTimestamp(String timestamp) {
    try {
      return DateTime.parse(timestamp);
    } catch (_) {
      return DateTime.now();
    }
  }
}
