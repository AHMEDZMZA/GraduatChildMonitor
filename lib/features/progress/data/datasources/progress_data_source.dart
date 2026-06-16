import 'package:child_monitor_app/core/network/api_client.dart';

/// Abstract data source contract for the Progress feature.
/// The repository depends on this abstraction — not on [ApiClient] directly.
abstract class ProgressDataSource {
  Future<HomeProgressResponse> getChildProgress(String childId);
}

/// Concrete implementation that delegates to [ApiClient].
class ProgressDataSourceImpl implements ProgressDataSource {
  final ApiClient apiClient;

  ProgressDataSourceImpl({required this.apiClient});

  @override
  Future<HomeProgressResponse> getChildProgress(String childId) async {
    final response = await apiClient.getHomeProgress(childId);
    return response.data;
  }
}
