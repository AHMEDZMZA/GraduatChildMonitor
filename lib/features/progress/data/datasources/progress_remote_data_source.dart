import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/progress_model.dart';

part 'progress_remote_data_source.g.dart';

@RestApi()
abstract class ProgressRemoteDataSource {
  factory ProgressRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProgressRemoteDataSource;

  @GET('/home/progress')
  Future<ProgressSummaryModel> getProgressSummary();

  @GET('/monthly-assessment/trend/{childId}')
  Future<TrendModel> getTrend(@Path('childId') String childId);

  @GET('/activities/stats/{childId}')
  Future<ActivityStatsModel> getActivityStats(@Path('childId') String childId);
}
