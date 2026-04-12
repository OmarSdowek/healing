import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../manger/faqs_logic/logic.dart';
import '../widgets/faqs_item.dart';

class DoctorFaqsScreen extends StatelessWidget {
  const DoctorFaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "q": "What is this app used for?",
        "a": "This app is used for booking doctor appointments easily."
      },
      {
        "q": "How do I register?",
        "a": "You can register by providing your personal information and creating an account."
      },
      {
        "q": "Is my data secure?",
        "a": "Yes, your data is protected according to our privacy policy."
      },
    ];

    return BlocProvider(
      create: (_) => DoctorFaqsCubit(faqs.length),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                const CustomHeader(title: "FAQs"),
                const SizedBox(height: 20),

                Expanded(
                  child: BlocBuilder<DoctorFaqsCubit, List<bool>>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: faqs.length,
                        itemBuilder: (_, i) {
                          return DoctorFaqItem(
                            question: faqs[i]["q"]!,
                            answer: faqs[i]["a"]!,
                            isExpanded: state[i],
                            onToggle: () =>
                                context.read<DoctorFaqsCubit>().toggle(i),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
