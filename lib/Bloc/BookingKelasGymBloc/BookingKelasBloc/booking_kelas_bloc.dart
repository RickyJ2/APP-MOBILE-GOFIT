import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasBloc/booking_kelas_event.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasBloc/booking_kelas_state.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';

import '../../../StateBlocTemplate/form_submission_state.dart';

class BookingKelasBloc extends Bloc<BookingKelasEvent, BookingKelasState> {
  final BookingKelasRepository bookingKelasRepository;

  BookingKelasBloc({required this.bookingKelasRepository})
      : super(BookingKelasState()) {
    on<BookingKelasJadwalHarianChanged>(
        (event, emit) => _onBookingKelasJadwalHarianChanged(event, emit));
    on<BookingKelasFormSubmitted>(
        (event, emit) => _onBookingKelasFormSubmitted(event, emit));
  }

  void _onBookingKelasJadwalHarianChanged(
      BookingKelasJadwalHarianChanged event, Emitter<BookingKelasState> emit) {
    emit(state.copyWith(
        jadwalHarian: event.jadwalHarian,
        formSubmissionState: const InitialFormState()));
  }

  void _onBookingKelasFormSubmitted(
      BookingKelasFormSubmitted event, Emitter<BookingKelasState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      await bookingKelasRepository.add(state.jadwalHarian.id);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on FailedToLoadBookingKelas catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    } on HttpException catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    }
  }
}
