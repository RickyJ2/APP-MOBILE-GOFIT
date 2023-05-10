import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/booking_kelas_gym_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/booking_kelas_gym_state.dart';

import '../Bloc/BookingKelasGymBloc/booking_kelas_gym_event.dart';
import '../const.dart';

class BookingKelasGymPage extends StatelessWidget {
  final Widget mainPageContent;
  const BookingKelasGymPage({super.key, required this.mainPageContent});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingKelasGymBloc>(
      create: (context) {
        return BookingKelasGymBloc();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Tambah Booking"),
            foregroundColor: textColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: BookingKelasGymView(mainPageContent: mainPageContent),
          ),
        ),
      ),
    );
  }
}

class BookingKelasGymView extends StatelessWidget {
  final Widget mainPageContent;
  const BookingKelasGymView({super.key, required this.mainPageContent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingKelasGymBloc, BookingKelasGymState>(
        builder: (context, state) {
      return Column(
        children: [
          ToggleButtons(
            onPressed: (index) => context.read<BookingKelasGymBloc>().add(
                  BookingKelasGymToogleChanged(toogleState: index),
                ),
            isSelected: state.toogleState,
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
          Expanded(child: mainPageContent),
        ],
      );
    });
  }
}
