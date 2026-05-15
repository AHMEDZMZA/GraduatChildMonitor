import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ChatRemoteDataSource {
  Future<ChatbotResponse> sendMessage(String message, {String? conversationId});
  Future<ChatHistoryResponse> getChatHistory({String? conversationId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChatbotResponse> sendMessage(
    String message, {
    String? conversationId,
  }) async {
    try {
      final response = await apiClient.sendChatMessage(
        ChatMessageRequest(
          message: message,
          conversationId: conversationId,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Send message failed: ${e.toString()}');
    }
  }

  @override
  Future<ChatHistoryResponse> getChatHistory({String? conversationId}) async {
    try {
      final response = await apiClient.getChatHistory(conversationId);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get chat history failed: ${e.toString()}',
      );
    }
  }

  ServerException _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(message: 'Unauthorized access');
    } else if (e.response?.statusCode == 404) {
      throw ServerException(message: 'Resource not found', statusCode: 404);
    } else if (e.response?.statusCode == 500) {
      throw ServerException(message: 'Server error', statusCode: 500);
    }
    throw ServerException(message: e.message ?? 'Unknown error');
  }
}
