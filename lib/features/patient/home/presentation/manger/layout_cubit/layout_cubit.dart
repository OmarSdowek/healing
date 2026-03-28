import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class LayoutCubit extends Cubit<int> {
  LayoutCubit() : super(0);
  void changeTab(int index) {
    emit(index);
  }
}
