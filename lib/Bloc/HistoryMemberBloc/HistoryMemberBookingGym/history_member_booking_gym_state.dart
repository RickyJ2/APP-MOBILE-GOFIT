import 'package:mobile_gofit/Model/booking_gym.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HistoryMemberBookingGymState {
  final List<BookingGym> bookingGymList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState cancelBookingGymState;

  HistoryMemberBookingGymState({
    this.bookingGymList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.cancelBookingGymState = const InitialFormState(),
  });

  HistoryMemberBookingGymState copyWith({
    List<BookingGym>? bookingGymList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? cancelBookingGymState,
  }) {
    return HistoryMemberBookingGymState(
      bookingGymList: bookingGymList ?? this.bookingGymList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      cancelBookingGymState:
          cancelBookingGymState ?? this.cancelBookingGymState,
    );
  }
}
