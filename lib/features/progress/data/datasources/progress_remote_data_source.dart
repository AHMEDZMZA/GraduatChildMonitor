import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_client.dart';
import '../models/progress_model.dart';

part 'progress_remote_data_source.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ProgressRemoteDataSource {
factory ProgressRemoteDataSource(Dio dio, {String baseUrl}) =
    _ProgressRemoteDataSource;

@GET('home/progress')
Future<ProgressSummaryModel> getProgressSummary(
  @Query('childId') String childId,
);

@GET('monthly-assessment/trend/{childId}')
Future<TrendModel> getTrend(@Path('childId') String childId);

@POST('activities/stats')
Future<ActivityStatsModel> getActivityStats(
  @Body() Map<String, dynamic> body,
);
}
