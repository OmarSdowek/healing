part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeDoctorsLoaded extends HomeState {
  final List<DoctorEntity> doctors;
  HomeDoctorsLoaded(this.doctors);
}

class HomeDepartmentsLoaded extends HomeState {
  final List<DepartmentModel> departments;
  HomeDepartmentsLoaded(this.departments);
}

class HomeDataLoaded extends HomeState {
  final List<DoctorEntity> doctors;
  final List<DepartmentModel> departments;
  final int? selectedDepartmentId;

  HomeDataLoaded({
    required this.doctors,
    required this.departments,
    this.selectedDepartmentId,
  });

  HomeDataLoaded copyWith({
    List<DoctorEntity>? doctors,
    List<DepartmentModel>? departments,
    int? selectedDepartmentId,
    bool clearSelectedDepartment = false,
  }) {
    return HomeDataLoaded(
      doctors: doctors ?? this.doctors,
      departments: departments ?? this.departments,
      selectedDepartmentId: clearSelectedDepartment
          ? null
          : (selectedDepartmentId ?? this.selectedDepartmentId),
    );
  }
}
