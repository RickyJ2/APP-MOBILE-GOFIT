import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingKelas/history_member_booking_kelas_event.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingKelas/history_member_booking_kelas_state.dart';
import 'package:mobile_gofit/Model/booking_kelas.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HistoryMemberBookingKelasBloc extends Bloc<HistoryMemberBookingKelasEvent,
    HistoryMemberBookingKelasState> {
  final BookingKelasRepository bookingKelasRepository;

  HistoryMemberBookingKelasBloc({required this.bookingKelasRepository})
      : super(HistoryMemberBookingKelasState()) {
    on<HistoryMemberPageFetchedRequested>(
        (event, emit) => _onHistoryMemberPageFetchedRequested(event, emit));
    on<CancelBookingKelasRequested>(
        (event, emit) => _onCancelBookingKelasRequested(event, emit));
    on<HistoryMemberBookingKelasDateChanged>(
        (event, emit) => _onHistoryMemberDateChanged(event, emit));
  }

  void _onHistoryMemberPageFetchedRequested(
      HistoryMemberPageFetchedRequested event,
      Emitter<HistoryMemberBookingKelasState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        cancelBookingKelasState: const InitialFormState()));
    try {
      List<BookingKelas> bookingKelasList = [];
      if (state.startDate == '' && state.endDate == '') {
        bookingKelasList = await bookingKelasRepository.show();
      } else {
        bookingKelasList = await bookingKelasRepository.showFilter(
            state.startDate, state.endDate);
      }
      emit(state.copyWith(
        bookingKelasList: bookingKelasList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingKelasList),
      ));
    } on FailedToLoadBookingKelas catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onCancelBookingKelasRequested(CancelBookingKelasRequested event,
      Emitter<HistoryMemberBookingKelasState> emit) async {
    emit(state.copyWith(
        cancelBookingKelasState: FormSubmitting(),
        pageFetchedDataState: const InitialPageFetchedDataState()));
    try {
      await bookingKelasRepository.cancel(event.id);
      emit(state.copyWith(cancelBookingKelasState: SubmissionSuccess()));
    } on FailedToLoadBookingKelas catch (e) {
      emit(
          state.copyWith(cancelBookingKelasState: SubmissionFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(
          cancelBookingKelasState: SubmissionFailed(e.toString())));
    }
  }

  void _onHistoryMemberDateChanged(HistoryMemberBookingKelasDateChanged event,
      Emitter<HistoryMemberBookingKelasState> emit) {
    if (event.startDate == state.startDate && event.endDate == state.endDate) {
      return;
    }
    emit(state.copyWith(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
    add(HistoryMemberPageFetchedRequested());
  }
}
