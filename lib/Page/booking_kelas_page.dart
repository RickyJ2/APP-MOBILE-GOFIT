import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Asset/card_jadwal_harian.dart';
import 'package:mobile_gofit/Asset/create_text_form_field.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasBloc/booking_kelas_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasBloc/booking_kelas_event.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasBloc/booking_kelas_state.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Model/jadwal_harian.dart';
import '../Model/member.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../const.dart';

class BookingKelasPage extends StatelessWidget {
  final JadwalHarian jadwalHarianSelected;
  const BookingKelasPage({super.key, required this.jadwalHarianSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingKelasBloc>(
        create: (context) {
          return BookingKelasBloc(
              bookingKelasRepository: BookingKelasRepository());
        },
        child: BookingKelasView(jadwalHarianSelected: jadwalHarianSelected));
  }
}

class BookingKelasView extends StatefulWidget {
  final JadwalHarian jadwalHarianSelected;
  const BookingKelasView({super.key, required this.jadwalHarianSelected});

  @override
  State<BookingKelasView> createState() => _BookingKelasViewState();
}

class _BookingKelasViewState extends State<BookingKelasView> {
  @override
  void initState() {
    super.initState();
    context.read<BookingKelasBloc>().add(BookingKelasJadwalHarianChanged(
        jadwalHarian: widget.jadwalHarianSelected));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingKelasBloc, BookingKelasState>(
      listenWhen: (previous, current) =>
          previous.formSubmissionState != current.formSubmissionState,
      listener: (context, state) {
        if (state.formSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Booking Kelas Berhasil"),
          ));
          Navigator.of(context).pop();
        } else if (state.formSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text((state.formSubmissionState as SubmissionFailed).exception),
          ));
        }
      },
      child: BlocBuilder<BookingKelasBloc, BookingKelasState>(
          builder: (context, state) {
        return Form(
          child: Column(
            children: [
              CreateTextFormField(
                labelText: "Member",
                hintText: "Member",
                initialValue: (BlocProvider.of<AppBloc>(context).state.user.user
                        as Member)
                    .nama,
                enabled: false,
              ),
              const SizedBox(height: 20.0),
              state.jadwalHarian.isEmpty
                  ? OutlinedButton(
                      onPressed: () {
                        context.push('/booking-kelas-list');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: primaryColor,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 70.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.queue,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8.0),
                            const Text('Pilih Jadwal Harian'),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        CardJadwalHarian(jadwalHarian: state.jadwalHarian),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            foregroundColor: errorTextColor,
                            elevation: 0,
                            mini: true,
                            onPressed: () {
                              context.read<BookingKelasBloc>().add(
                                  BookingKelasJadwalHarianChanged(
                                      jadwalHarian: JadwalHarian.empty));
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ],
                    ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<BookingKelasBloc>()
                        .add(BookingKelasFormSubmitted());
                  },
                  child: Stack(
                    children: [
                      state.formSubmissionState is FormSubmitting
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          state.formSubmissionState is! FormSubmitting
                              ? 'Booking Kelas'
                              : '',
                          style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            fontSize: 15,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
