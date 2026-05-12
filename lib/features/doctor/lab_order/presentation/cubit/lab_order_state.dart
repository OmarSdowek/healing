part of 'lab_order_cubit.dart';

abstract class LabOrderState {}

class LabOrderSelecting extends LabOrderState {
  final Set<String> selectedTests;
  LabOrderSelecting(this.selectedTests);
}

class LabOrderLoading extends LabOrderState {}

class LabOrderSuccess extends LabOrderState {
  final LabOrderEntity order;
  LabOrderSuccess(this.order);
}

class LabOrderError extends LabOrderState {
  final String message;
  LabOrderError(this.message);
}
