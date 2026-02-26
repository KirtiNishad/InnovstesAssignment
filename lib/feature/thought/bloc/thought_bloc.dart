import 'package:bloc/bloc.dart';
import 'package:innovate_assignment/feature/thought/model/thought_data_repo.dart';
import 'package:innovate_assignment/feature/thought/model/thought_model.dart';
import 'package:meta/meta.dart';

part 'thought_event.dart';
part 'thought_state.dart';

class ThoughtBloc extends Bloc<ThoughtEvent, ThoughtState> {
  ThoughtBloc() : super(ThoughtInitial()) {
    on<ThoughtFetchEvent>((event, emit) async {
      try {
        emit(ThoughtInitial());
        List<dynamic> data = await ThoughtDataRepo().getThoughtOfDay();
        emit(ThoughtSuccess(data));
      } catch (e) {
        print("error =========> $e");
        emit(ThoughtError(e.toString()));
      }
    });
  }
}
