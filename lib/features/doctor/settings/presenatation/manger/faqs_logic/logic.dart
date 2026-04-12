import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorFaqsCubit extends Cubit<List<bool>> {
  DoctorFaqsCubit(int count) : super(List.generate(count, (_) => false));

  void toggle(int index) {
    final newState = List<bool>.from(state);
    newState[index] = !newState[index];
    emit(newState);
  }
}
