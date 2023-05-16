import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingGymBloc/booking_gym_event.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingGymBloc/booking_gym_state.dart';
import 'package:mobile_gofit/Model/booking_gym.dart';
import 'package:mobile_gofit/Model/sesi_gym.dart';
import 'package:mobile_gofit/Repository/booking_gym_repository.dart';
import 'package:mobile_gofit/Repository/sesi_gym_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../../StateBlocTemplate/form_submission_state.dart';

class BookingGymBloc extends Bloc<BookingGymEvent, BookingGymState> {
  final BookingGymRepository bookingGymRepository;
  final SesiGymRepository sesiGymRepository;

  BookingGymBloc(
      {required this.bookingGymRepository, required this.sesiGymRepository})
      : super(BookingGymState()) {
    on<BookingGymPageDataRequested>(
        (event, emit) => _onBookingGymPageDataRequested(event, emit));

    on<BookingGymFormChanged>(
        (event, emit) => _onBookingGymFormChanged(event, emit));
    on<BookingGymFormSubmitted>(
        (event, emit) => _onBookingGymFormSubmitted(event, emit));
  }

  void _onBookingGymPageDataRequested(
      BookingGymPageDataRequested event, Emitter<BookingGymState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        formSubmissionState: const InitialFormState()));
    try {
      final listSesiGym = await sesiGymRepository.get();
      listSesiGym.insert(0, SesiGym.empty);
      emit(state.copyWith(
          listSesiGym: listSesiGym,
          pageFetchedDataState: PageFetchedDataSuccess(listSesiGym)));
    } on FailedToLoadSesiGym catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    }
  }

  void _onBookingGymFormChanged(
      BookingGymFormChanged event, Emitter<BookingGymState> emit) {
    emit(state.copyWith(
      bookingGymForm: event.bookingGym,
      pageFetchedDataState: const InitialPageFetchedDataState(),
      formSubmissionState: const InitialFormState(),
    ));
  }

  void _onBookingGymFormSubmitted(
      BookingGymFormSubmitted event, Emitter<BookingGymState> emit) async {
    emit(state.copyWith(
      formSubmissionState: FormSubmitting(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      bookingGymError: BookingGym.empty,
    ));
    try {
      await bookingGymRepository.add(state.bookingGymForm);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on ErrorValidateFromBookingGym catch (e) {
      emit(state.copyWith(
          bookingGymError: e.bookingGym,
          formSubmissionState: SubmissionFailed(e.toString())));
    } on FailedToLoadBookingGym catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    } on HttpException catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    }
  }
}
