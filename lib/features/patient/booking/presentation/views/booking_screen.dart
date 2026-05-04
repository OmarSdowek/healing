import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../../home/domin/entity/doctor_entity.dart';
import '../manger/booking_cubit.dart';
import '../widgets/day_selector.dart';
import '../widgets/doctor_profile.dart';
import '../widgets/price_pay_section.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorEntity? doctor;
  const BookAppointmentScreen({super.key, this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DoctorEntity? _selectedDoctor;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  String? selectedSlotStart;
  String? selectedSlotEnd;

  // Keep slots state separately so it survives doctor/date changes
  List<dynamic> _currentSlots = [];
  bool _slotsLoading = false;
  String? _slotsError;

  @override
  void initState() {
    super.initState();
    _selectedDoctor = widget.doctor;
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: Builder(builder: (ctx) {
        return BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSlotsLoading) {
              setState(() {
                _slotsLoading = true;
                _slotsError = null;
                _currentSlots = [];
              });
            } else if (state is BookingSlotsLoaded) {
              setState(() {
                _slotsLoading = false;
                _currentSlots = state.slots;
              });
            } else if (state is BookingError && _slotsLoading) {
              setState(() {
                _slotsLoading = false;
                _slotsError = state.message;
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(title: "Book Appointment"),
                    context.verticalSpace(20),

                    // ── Doctor Picker ──────────────────────────────────────
                    Text("Doctor", style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(8),

                    _selectedDoctor == null
                        ? _DoctorPickerTile(
                            onTap: () =>
                                _showDoctorPicker(ctx),
                          )
                        : _SelectedDoctorCard(
                            doctor: _selectedDoctor!,
                            onChangeTap: () =>
                                _showDoctorPicker(ctx),
                          ),

                    context.verticalSpace(24),

                    // ── Day Selector ───────────────────────────────────────
                    if (_selectedDoctor != null) ...[
                      DaySelector(
                        focusedDay: focusedDay,
                        selectedDay: selectedDay,
                        onDaySelected: (selected, focused) {
                          setState(() {
                            selectedDay = selected;
                            focusedDay = focused;
                            selectedSlotStart = null;
                            selectedSlotEnd = null;
                            _currentSlots = [];
                          });
                          ctx.read<BookingCubit>().loadSlots(
                                doctorId: _selectedDoctor!.id,
                                date: _formatDate(selected),
                              );
                        },
                      ),
                      context.verticalSpace(24),
                    ],

                    // ── Time Slots ─────────────────────────────────────────
                    if (selectedDay != null && _selectedDoctor != null) ...[
                      Text("Available Slots",
                          style: AppTextStyles.semiBold16Black),
                      context.verticalSpace(12),

                      if (_slotsLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_slotsError != null)
                        _EmptySlots(
                          message: "No slots available.\nTry another date.",
                        )
                      else if (_currentSlots.isEmpty)
                        _EmptySlots(
                          message: "No slots available.\nTry another date.",
                        )
                      else
                        _SlotsGrid(
                          slots: _currentSlots,
                          selectedStart: selectedSlotStart,
                          onSelect: (start, end) {
                            setState(() {
                              selectedSlotStart = start;
                              selectedSlotEnd = end;
                            });
                          },
                        ),
                    ],

                    context.verticalSpace(100),
                  ],
                ),
              ),
            ),

            // ── Bottom Bar ─────────────────────────────────────────────────
            bottomNavigationBar: PriceAndPaySection(
              text: "Continue",
              onPressed: () => _onContinue(context),
            ),
          ),
        );
      }),
    );
  }

  void _onContinue(BuildContext context) {
    if (_selectedDoctor == null) {
      _snack(context, "Please select a doctor");
      return;
    }
    if (selectedDay == null) {
      _snack(context, "Please select a date");
      return;
    }
    if (selectedSlotStart == null) {
      _snack(context, "Please select a time slot");
      return;
    }

    // Get patientId from PatientAuthCubit (available via IndexedStack parent)
    int patientId = 1;
    try {
      final authState = context.read<PatientAuthCubit>().state;
      if (authState is PatientDataSuccess) {
        patientId = int.tryParse(authState.meData.patientId ?? '1') ?? 1;
      }
    } catch (_) {}

    Navigator.pushNamed(
      context,
      Routes.appointmentConfirmation,
      arguments: {
        'doctor': _selectedDoctor!,
        'date': _formatDate(selectedDay!),
        'startTime': selectedSlotStart!,
        'endTime': selectedSlotEnd ?? '',
        'patientId': patientId,
      },
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showDoctorPicker(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: ctx.read<BookingCubit>(),
        child: _DoctorPickerSheet(
          onSelected: (doctor) {
            setState(() {
              _selectedDoctor = doctor;
              selectedDay = null;
              selectedSlotStart = null;
              selectedSlotEnd = null;
              _currentSlots = [];
            });
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }
}

// ─── Doctor Picker Tile (empty state) ────────────────────────────────────────

class _DoctorPickerTile extends StatelessWidget {
  final VoidCallback onTap;
  const _DoctorPickerTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_search,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select a Doctor",
                      style: AppTextStyles.semiBold16Black),
                  const SizedBox(height: 2),
                  Text(
                    "Tap to browse available doctors",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Selected Doctor Card ─────────────────────────────────────────────────────

class _SelectedDoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final VoidCallback onChangeTap;

  const _SelectedDoctorCard({
    required this.doctor,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        doctor.pictureUrl.replaceFirst('localhost', '10.0.2.2');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          // Avatar — uses DoctorAvatar with resolveImageUrl
          DoctorAvatar(pictureUrl: doctor.pictureUrl, radius: 28),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.fullName,
                    style: AppTextStyles.semiBold16Black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  doctor.specialization,
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: Colors.grey, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "${doctor.consultationFee.toStringAsFixed(0)} EGP",
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: AppColors.primary, fontSize: 13),
                ),
              ],
            ),
          ),

          // Change button
          TextButton(
            onPressed: onChangeTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              "Change",
              style: AppTextStyles.semiBold16Black
                  .copyWith(color: AppColors.primary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Doctor Picker Bottom Sheet ───────────────────────────────────────────────

class _DoctorPickerSheet extends StatefulWidget {
  final ValueChanged<DoctorEntity> onSelected;
  const _DoctorPickerSheet({required this.onSelected});

  @override
  State<_DoctorPickerSheet> createState() => _DoctorPickerSheetState();
}

class _DoctorPickerSheetState extends State<_DoctorPickerSheet> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    // Load doctors when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BookingCubit>().loadDoctors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Select Doctor",
                        style: AppTextStyles.semiBold24dark
                            .copyWith(fontSize: 18)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: "Search doctor or speciality...",
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),

              // List
              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is BookingDoctorsLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (state is BookingError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text(state.message,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red.shade700)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<BookingCubit>()
                                  .loadDoctors(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is BookingDoctorsLoaded) {
                      final filtered = _search.isEmpty
                          ? state.doctors
                          : state.doctors
                              .where((d) =>
                                  d.fullName
                                      .toLowerCase()
                                      .contains(_search) ||
                                  d.specialization
                                      .toLowerCase()
                                      .contains(_search))
                              .toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text("No doctors found"),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final d = filtered[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            leading: DoctorAvatar(
                              pictureUrl: d.pictureUrl,
                              radius: 26,
                            ),
                            title: Text(d.fullName,
                                style: AppTextStyles.semiBold16Black),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.specialization,
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(
                                          color: Colors.grey, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${d.consultationFee.toStringAsFixed(0)} EGP",
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 13),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Select",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            onTap: () => widget.onSelected(d),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Slots Grid ───────────────────────────────────────────────────────────────

class _SlotsGrid extends StatelessWidget {
  final List<dynamic> slots;
  final String? selectedStart;
  final void Function(String start, String end) onSelect;

  const _SlotsGrid({
    required this.slots,
    required this.selectedStart,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isSelected = selectedStart == slot.startTime;
        final isAvailable = slot.isAvailable as bool;
        final label = (slot.startTime as String).substring(0, 5);

        return GestureDetector(
          onTap: isAvailable
              ? () => onSelect(slot.startTime, slot.endTime)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: !isAvailable
                  ? Colors.grey.shade100
                  : isSelected
                      ? AppColors.primary
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: !isAvailable
                    ? Colors.grey.shade200
                    : isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: !isAvailable
                    ? Colors.grey.shade400
                    : isSelected
                        ? Colors.white
                        : Colors.black87,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Empty Slots ──────────────────────────────────────────────────────────────

class _EmptySlots extends StatelessWidget {
  final String message;
  const _EmptySlots({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
