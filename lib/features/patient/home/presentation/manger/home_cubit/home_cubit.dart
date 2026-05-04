import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/department_model.dart';
import '../../../domin/entity/doctor_entity.dart';
import '../../../domin/use_cases/get_departments_use_case.dart';
import '../../../domin/use_cases/get_doctor_use_case.dart';
import '../../../domin/use_cases/get_doctors_by_department_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDoctorUseCase getDoctorsUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetDoctorsByDepartmentUseCase getDoctorsByDepartmentUseCase;

  HomeCubit(
    this.getDoctorsUseCase,
    this.getDepartmentsUseCase,
    this.getDoctorsByDepartmentUseCase,
  ) : super(HomeInitial());

  List<DoctorEntity> _allDoctors = [];
  List<DepartmentModel> _departments = [];

  /// Load both doctors and departments
  Future<void> loadHomeData() async {
    print("🔥 HomeCubit: loadHomeData() called");
    emit(HomeLoading());

    try {
      print("🔥 HomeCubit: Loading departments and doctors in parallel...");

      // Run both calls in parallel with explicit typed futures
      final departmentsFuture = getDepartmentsUseCase();
      final doctorsFuture = getDoctorsUseCase();

      final departmentsResult = await departmentsFuture;
      final doctorsResult = await doctorsFuture;
      print("🔥 HomeCubit: Got results - departments: ${departmentsResult.isRight()}, doctors: ${doctorsResult.isRight()}");

      // Extract departments — fallback to extracting from doctors if API returns 403/404
      List<DepartmentModel> departments = [];

      departmentsResult.fold(
        (failure) {
          print("❌ HomeCubit: Departments failed: ${failure.massage}");
          // Fallback: build department list from doctors
          doctorsResult.fold(
            (_) => departments = [],
            (doctors) {
              final seen = <int>{};
              for (final doctor in doctors) {
                if (seen.add(doctor.departmentId)) {
                  departments.add(DepartmentModel(
                    id: doctor.departmentId,
                    name: doctor.departmentName,
                    phoneExtension: null,
                  ));
                }
              }
              print("✅ HomeCubit: Extracted ${departments.length} departments from doctors (fallback)");
            },
          );
        },
        (depts) {
          print("✅ HomeCubit: Got ${depts.length} departments from API");
          departments = depts;
          _departments = depts;
        },
      );

      // Emit state based on doctors result
      doctorsResult.fold(
        (failure) {
          print("❌ HomeCubit: Doctors failed: ${failure.massage}");
          emit(HomeError(failure.massage));
        },
        (doctors) {
          print("✅ HomeCubit: Got ${doctors.length} doctors");
          _allDoctors = doctors;
          _departments = departments;
          print("🎉 HomeCubit: Emitting HomeDataLoaded with ${doctors.length} doctors, ${departments.length} departments");
          emit(HomeDataLoaded(
            doctors: doctors,
            departments: departments,
          ));
        },
      );
    } catch (e, stack) {
      print("❌ HomeCubit: Exception in loadHomeData: $e");
      print("❌ StackTrace: $stack");
      emit(HomeError("Failed to load home data: $e"));
    }
  }

  /// Filter doctors by department
  Future<void> filterByDepartment(int? deptId) async {
    if (state is! HomeDataLoaded) return;

    final currentState = state as HomeDataLoaded;

    if (deptId == null) {
      // Show all doctors
      emit(currentState.copyWith(
        doctors: _allDoctors,
        clearSelectedDepartment: true,
      ));
      return;
    }

    emit(HomeLoading());

    final result = await getDoctorsByDepartmentUseCase(deptId);

    result.fold(
      (failure) => emit(HomeError(failure.massage)),
      (doctors) {
        emit(HomeDataLoaded(
          doctors: doctors,
          departments: _departments,
          selectedDepartmentId: deptId,
        ));
      },
    );
  }

  /// Load doctors for a specific department directly (used by DoctorsByDepartmentScreen)
  Future<void> filterByDepartmentDirect(int deptId) async {
    print("🔥 HomeCubit: filterByDepartmentDirect($deptId) called");
    emit(HomeLoading());

    final result = await getDoctorsByDepartmentUseCase(deptId);

    result.fold(
      (failure) {
        print("❌ HomeCubit: filterByDepartmentDirect error: ${failure.massage}");
        emit(HomeError(failure.massage));
      },
      (doctors) {
        print("✅ HomeCubit: Got ${doctors.length} doctors for dept $deptId");
        emit(HomeDataLoaded(
          doctors: doctors,
          departments: _departments,
          selectedDepartmentId: deptId,
        ));
      },
    );
  }

  /// Search doctors by name or specialization
  Future<void> searchDoctors(String query) async {
    if (query.trim().isEmpty) {
      // Reset to all doctors
      emit(HomeDataLoaded(
        doctors: _allDoctors,
        departments: _departments,
      ));
      return;
    }

    emit(HomeLoading());

    final result = await getDoctorsUseCase();

    result.fold(
      (failure) => emit(HomeError(failure.massage)),
      (doctors) {
        final q = query.toLowerCase();
        final filtered = doctors
            .where((d) =>
                d.fullName.toLowerCase().contains(q) ||
                d.specialization.toLowerCase().contains(q) ||
                d.departmentName.toLowerCase().contains(q))
            .toList();
        emit(HomeDataLoaded(
          doctors: filtered,
          departments: _departments,
        ));
      },
    );
  }

  /// Legacy method for backward compatibility
  Future<void> getDoctors() async {
    emit(HomeLoading());

    final result = await getDoctorsUseCase();

    result.fold(
      (failure) => emit(HomeError(failure.massage)),
      (doctors) => emit(HomeDoctorsLoaded(doctors)),
    );
  }
}
