import '../../../../core/network/api_client.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataResponse> getHomeData(String? childId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<HomeDataResponse> getHomeData(String? childId) async {
    final response = await apiClient.getHomeData(childId);
    return response.data;
  }
}
