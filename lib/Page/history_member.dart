import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/history_member_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/history_member_event.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/history_member_state.dart';
import 'package:mobile_gofit/Page/history_booking_gym_page.dart';
import 'package:mobile_gofit/Page/history_booking_kelas_page.dart';

import '../const.dart';

class HistoryMemberPage extends StatelessWidget {
  final int gymKelas;
  const HistoryMemberPage({super.key, required this.gymKelas});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryMemberBloc>(
      create: (context) => HistoryMemberBloc(),
      child: HistoryMemberView(gymKelas: gymKelas),
    );
  }
}

class HistoryMemberView extends StatefulWidget {
  final int gymKelas;
  const HistoryMemberView({super.key, required this.gymKelas});

  @override
  State<HistoryMemberView> createState() => _HistoryMemberViewState();
}

class _HistoryMemberViewState extends State<HistoryMemberView> {
  @override
  void initState() {
    super.initState();
    context
        .read<HistoryMemberBloc>()
        .add(HistoryMemberToogleChanged(toogleState: widget.gymKelas));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryMemberBloc, HistoryMemberState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              onPressed: (index) => context.read<HistoryMemberBloc>().add(
                    HistoryMemberToogleChanged(toogleState: index),
                  ),
              isSelected: state.toggleState,
              borderRadius: BorderRadius.circular(10),
              selectedColor: textColor,
              fillColor: primaryColor,
              color: accentColor,
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 220,
                minHeight: 50,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Booking Gym'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Booking Kelas'),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            state.toggleState[0]
                ? const HistoryBookingGymPage()
                : const HistoryBookingKelasPage(),
          ],
        );
      },
    );
  }
}
