import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeCubit(this.getHomeDataUseCase) : super(HomeInitial());

  Future<void> getHomeData({String? childId}) async {
    emit(HomeLoading());
    final result = await getHomeDataUseCase(childId: childId);
    
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeSuccess(data)),
    );
  }
}
