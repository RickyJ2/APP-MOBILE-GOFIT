import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingGymBloc/booking_gym_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingGymBloc/booking_gym_event.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingGymBloc/booking_gym_state.dart';
import 'package:mobile_gofit/Model/sesi_gym.dart';
import 'package:mobile_gofit/Repository/booking_gym_repository.dart';
import 'package:mobile_gofit/Repository/sesi_gym_repository.dart';

import '../Asset/create_drop_down_button.dart';
import '../Asset/create_text_form_field.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Model/member.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class BookingGymPage extends StatelessWidget {
  const BookingGymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingGymBloc>(
        create: (context) {
          return BookingGymBloc(
            bookingGymRepository: BookingGymRepository(),
            sesiGymRepository: SesiGymRepository(),
          );
        },
        child: const BookingGymView());
  }
}

class BookingGymView extends StatefulWidget {
  const BookingGymView({super.key});

  @override
  State<BookingGymView> createState() => _BookingGymViewState();
}

class _BookingGymViewState extends State<BookingGymView> {
  final TextEditingController _tglBookingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookingGymBloc>().add(BookingGymPageDataRequested());
    _tglBookingController.addListener(_onTglBookingChanged);
  }

  @override
  void dispose() {
    _tglBookingController.dispose();
    super.dispose();
  }

  void _onTglBookingChanged() {
    final newValue = _tglBookingController.text;
    context.read<BookingGymBloc>().add(
          BookingGymFormChanged(
            bookingGym:
                context.read<BookingGymBloc>().state.bookingGymForm.copyWith(
                      tanggal: newValue,
                    ),
          ),
        );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initTime = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _tglBookingController.text =
          '${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingGymBloc, BookingGymState>(
      listenWhen: (previous, current) =>
          previous.formSubmissionState != current.formSubmissionState ||
          previous.pageFetchedDataState != current.pageFetchedDataState,
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((state.pageFetchedDataState as PageFetchedDataFailed)
                .exception),
          ));
        }
        if (state.formSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Booking Gym Berhasil"),
          ));
          Navigator.of(context).pop();
        }
        if (state.formSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text((state.formSubmissionState as SubmissionFailed).exception),
          ));
        }
      },
      child: BlocBuilder<BookingGymBloc, BookingGymState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        CreateTextFormField(
                          labelText: "Member",
                          hintText: "Member",
                          initialValue: (BlocProvider.of<AppBloc>(context)
                                  .state
                                  .user
                                  .user as Member)
                              .nama,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        CreateTextFormField(
                          controller: _tglBookingController,
                          labelText: "Tanggal Booking",
                          hintText: "Pilih tanggal booking",
                          validator: (value) =>
                              state.bookingGymError.tanggal == ''
                                  ? null
                                  : state.bookingGymError.tanggal,
                          onTap: () => _selectDate(context),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CreateDropDownButton(
                          label: "Sesi Gym",
                          errorText: state.bookingGymError.sesiGym.id == ''
                              ? null
                              : state.bookingGymError.sesiGym.id,
                          value: state.bookingGymForm.sesiGym,
                          items: state.listSesiGym
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child:
                                        Text('${e.jamMulai} - ${e.jamSelesai}'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            context.read<BookingGymBloc>().add(
                                  BookingGymFormChanged(
                                    bookingGym: state.bookingGymForm
                                        .copyWith(sesiGym: value as SesiGym),
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<BookingGymBloc>()
                                  .add(BookingGymFormSubmitted());
                            },
                            child: Stack(
                              children: [
                                state.formSubmissionState is FormSubmitting
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    state.formSubmissionState is! FormSubmitting
                                        ? 'Booking Gym'
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
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
