import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorLayoutCubit extends Cubit<int> {
  DoctorLayoutCubit() : super(0);
  void changeTab(int index) => emit(index);
}
