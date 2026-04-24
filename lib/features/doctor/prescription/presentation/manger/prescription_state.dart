part of 'prescription_cubit.dart';

abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionSuccess extends PrescriptionState {
  final PrescriptionModel prescription;
  PrescriptionSuccess(this.prescription);
}

class PrescriptionError extends PrescriptionState {
  final String message;
  PrescriptionError(this.message);
}
