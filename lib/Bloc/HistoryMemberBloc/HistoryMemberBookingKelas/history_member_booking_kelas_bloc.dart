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
  }

  void _onHistoryMemberPageFetchedRequested(
      HistoryMemberPageFetchedRequested event,
      Emitter<HistoryMemberBookingKelasState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        cancelBookingKelasState: const InitialFormState()));
    try {
      List<BookingKelas> bookingKelasList = await bookingKelasRepository.show();
      emit(state.copyWith(
        bookingKelasList: bookingKelasList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingKelasList),
      ));
    } on FailedToLoadBookingKelas catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(
          cancelBookingKelasState: SubmissionFailed(e.toString())));
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
}
