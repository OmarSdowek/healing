import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lab_order_entity.dart';
import '../../domain/usecases/create_lab_order_usecase.dart';

part 'lab_order_state.dart';

class LabOrderCubit extends Cubit<LabOrderState> {
  final CreateLabOrderUseCase _createLabOrderUseCase;

  LabOrderCubit(this._createLabOrderUseCase)
      : super(LabOrderSelecting({}));

  void toggleTest(String test) {
    final current = state is LabOrderSelecting
        ? (state as LabOrderSelecting).selectedTests
        : <String>{};

    final updated = Set<String>.from(current);
    if (updated.contains(test)) {
      updated.remove(test);
    } else {
      updated.add(test);
    }
    emit(LabOrderSelecting(updated));
  }

  Future<void> submitOrder({
    required int recordId,
    required String clinicalIndication,
    String priority = 'Routine',
  }) async {
    final selected = state is LabOrderSelecting
        ? (state as LabOrderSelecting).selectedTests
        : <String>{};

    if (selected.isEmpty) {
      emit(LabOrderError('Please select at least one test'));
      emit(LabOrderSelecting({}));
      return;
    }

    emit(LabOrderLoading());

    final result = await _createLabOrderUseCase(
      CreateLabOrderParams(
        recordId: recordId,
        tests: selected.toList(),
        clinicalIndication: clinicalIndication,
        priority: priority,
      ),
    );

    result.fold(
      (failure) {
        emit(LabOrderError(failure.massage));
        emit(LabOrderSelecting(selected)); // restore selection
      },
      (order) => emit(LabOrderSuccess(order)),
    );
  }
}
