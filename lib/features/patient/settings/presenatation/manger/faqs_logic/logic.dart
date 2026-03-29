import 'package:flutter_bloc/flutter_bloc.dart';

class FaqsCubit extends Cubit<List<bool>> {
  FaqsCubit(int count) : super(List.generate(count, (_) => false));

  void toggle(int index) {
    final newState = List<bool>.from(state);
    newState[index] = !newState[index];
    emit(newState);
  }
}
