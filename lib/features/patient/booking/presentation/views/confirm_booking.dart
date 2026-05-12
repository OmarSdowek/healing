import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/helper/image_helper.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/services/local_notification_service.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../home/domin/entity/doctor_entity.dart';
import '../manger/booking_cubit.dart';
import '../widgets/doctor_profile.dart';
import '../widgets/payment_option.dart';
import '../widgets/price_pay_section.dart';
import '../../domin/entity/book_appointment_request.dart';

class ConfirmBooking extends StatefulWidget {
  final DoctorEntity doctor;
  final String date;
  final String startTime;
  final String endTime;
  final int patientId;

  const ConfirmBooking({
    super.key,
    required this.doctor,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.patientId,
  });

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  int selectedIndex = 0;

  String _fmt(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  String _paymentLabel() {
    switch (selectedIndex) {
      case 1:
        return "Stripe";
      case 2:
        return "Apple Pay";
      default:
        return "Credit Card";
    }
  }

  String get _imageUrl => resolveImageUrl(widget.doctor.pictureUrl) ?? '';

  @override
  Widget build(BuildContext context) {
    final fee = widget.doctor.consultationFee.toStringAsFixed(2);

    return BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            // Show local notification for booking confirmation
            LocalNotificationService.show(
              id: state.appointment.id,
              title: "Appointment Booked ✅",
              body:
                  "Your appointment with Dr. ${state.appointment.doctorName} on ${state.appointment.appointmentDate} at ${state.appointment.startTime.substring(0, 5)} is confirmed.",
            );

            Navigator.pushNamed(
              context,
              Routes.addNewCard,
              arguments: {
                'doctorName': state.appointment.doctorName,
                'speciality': state.appointment.doctorSpecialization,
                'doctorImage': _imageUrl,
                'date': state.appointment.appointmentDate,
                'startTime': state.appointment.startTime,
                'fees': fee,
                'paymentMethod': _paymentLabel(),
                'confirmationNumber': state.appointment.confirmationNumber,
                'appointmentId': state.appointment.id,
                'patientId': widget.patientId,
              },
            );
          } else if (state is BookingError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader(title: "Book Appointment"),
                      context.verticalSpace(20),

                      // ── Doctor Profile ──────────────────────────────────
                      DoctorProfileSection(
                        image: _imageUrl,
                        name: widget.doctor.fullName,
                        speciality: widget.doctor.specialization,
                        isFavorite: false,
                      ),

                      context.verticalSpace(15),

                      // ── Date & Time ─────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.date}  •  ${_fmt(widget.startTime)}"
                              "${widget.endTime.isNotEmpty ? ' – ${_fmt(widget.endTime)}' : ''}",
                              style: AppTextStyles.semiBold16Black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Reschedule",
                              style: AppTextStyles.reg20black.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      context.verticalSpace(20),

                      // ── Billing Breakdown ───────────────────────────────
                      Text(
                        "Billing Breakdown",
                        style: AppTextStyles.semiBold24dark
                            .copyWith(color: AppColors.black),
                      ),
                      context.verticalSpace(12),
                      Container(
                        padding: EdgeInsets.all(context.r(12)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(context.r(12)),
                        ),
                        child: Column(
                          children: [
                            _BillingRow(
                              title: "Consultation Fee",
                              amount: "$fee EGP",
                            ),
                            context.verticalSpace(8),
                            Divider(height: context.h(15)),
                            _BillingRow(
                              title: "Total",
                              amount: "$fee EGP",
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),

                      context.verticalSpace(20),

                      // ── Payment Method ──────────────────────────────────
                      Text("Payment Method",
                          style: AppTextStyles.semiBold24dark),
                      context.verticalSpace(15),

                      PaymentOption(
                        title: "Credit Card",
                        icons: [
                          AssetsManger.visa,
                          AssetsManger.masterCard,
                        ],
                        isSelected: selectedIndex == 0,
                        onTap: () => setState(() => selectedIndex = 0),
                      ),
                      PaymentOption(
                        title: "Stripe",
                        icons: [AssetsManger.masterCard],
                        isSelected: selectedIndex == 1,
                        onTap: () => setState(() => selectedIndex = 1),
                      ),
                      PaymentOption(
                        title: "Apple Pay",
                        icons: [AssetsManger.applePay],
                        isSelected: selectedIndex == 2,
                        onTap: () => setState(() => selectedIndex = 2),
                      ),

                      context.verticalSpace(25),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Pay Button ───────────────────────────────────────
            bottomNavigationBar: state is BookingLoading
                ? const SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(),
                  )
                : PriceAndPaySection(
                    text: "Pay with ${_paymentLabel()} – $fee EGP",
                    onPressed: () {
                      context.read<BookingCubit>().book(
                            BookAppointmentRequest(
                              patientId: widget.patientId,
                              doctorId: widget.doctor.id,
                              appointmentDate: widget.date,
                              startTime: widget.startTime,
                              type: "InPerson",
                              reasonForVisit: "Appointment via app",
                            ),
                          );
                    },
                  ),
          );
        },
      ),
    );
  }
}

// ─── Billing Row ─────────────────────────────────────────────────────────────

class _BillingRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const _BillingRow({
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.semiBold16Black
              : AppTextStyles.reg20black,
        ),
        Text(
          amount,
          style: isTotal
              ? AppTextStyles.semiBold16Black
                  .copyWith(color: AppColors.primaryDark)
              : AppTextStyles.reg20black,
        ),
      ],
    );
  }
}
