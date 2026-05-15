import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_child_progress_usecase.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetChildProgressUseCase getChildProgressUseCase;

  ProgressCubit({required this.getChildProgressUseCase}) : super(ProgressInitial());

  Future<void> fetchProgress(String childId) async {
    emit(ProgressLoading());
    final result = await getChildProgressUseCase(childId);
    result.fold(
      (failure) => emit(ProgressError(failure.message)),
      (progress) => emit(ProgressLoaded(progress)),
    );
  }
}
