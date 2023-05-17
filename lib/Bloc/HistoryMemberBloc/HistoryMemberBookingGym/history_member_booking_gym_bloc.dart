import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingGym/history_member_booking_gym_event.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingGym/history_member_booking_gym_state.dart';
import 'package:mobile_gofit/Model/booking_gym.dart';
import 'package:mobile_gofit/Repository/booking_gym_repository.dart';

import '../../../StateBlocTemplate/form_submission_state.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';

class HistoryMemberBookingGymBloc
    extends Bloc<HistoryMemberBookingGymEvent, HistoryMemberBookingGymState> {
  final BookingGymRepository bookingGymRepository;

  HistoryMemberBookingGymBloc({required this.bookingGymRepository})
      : super(HistoryMemberBookingGymState()) {
    on<HistoryMemberBookinGymFetchedRequested>((event, emit) =>
        _onHistoryMemberBookinGymFetchedRequested(event, emit));
    on<CancelBookingGymRequested>(
        (event, emit) => _onCancelBookingGymRequested(event, emit));
  }

  void _onHistoryMemberBookinGymFetchedRequested(
      HistoryMemberBookinGymFetchedRequested event,
      Emitter<HistoryMemberBookingGymState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        cancelBookingGymState: const InitialFormState()));
    try {
      List<BookingGym> bookingGymList = await bookingGymRepository.show();
      emit(state.copyWith(
        bookingGymList: bookingGymList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingGymList),
      ));
    } on FailedToLoadBookingGym catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(
          cancelBookingGymState: SubmissionFailed(e.toString())));
    }
  }

  void _onCancelBookingGymRequested(CancelBookingGymRequested event,
      Emitter<HistoryMemberBookingGymState> emit) async {
    emit(state.copyWith(
        cancelBookingGymState: FormSubmitting(),
        pageFetchedDataState: const InitialPageFetchedDataState()));
    try {
      await bookingGymRepository.cancel(event.id);
      emit(state.copyWith(cancelBookingGymState: SubmissionSuccess()));
    } on FailedToLoadBookingGym catch (e) {
      emit(state.copyWith(cancelBookingGymState: SubmissionFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(
          cancelBookingGymState: SubmissionFailed(e.toString())));
    }
  }
}
