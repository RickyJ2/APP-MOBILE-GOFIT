import 'package:mobile_gofit/Model/booking_kelas.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HistoryMemberBookingKelasState {
  final List<BookingKelas> bookingKelasList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState cancelBookingKelasState;

  HistoryMemberBookingKelasState({
    this.bookingKelasList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.cancelBookingKelasState = const InitialFormState(),
  });

  HistoryMemberBookingKelasState copyWith({
    List<BookingKelas>? bookingKelasList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? cancelBookingKelasState,
  }) {
    return HistoryMemberBookingKelasState(
      bookingKelasList: bookingKelasList ?? this.bookingKelasList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      cancelBookingKelasState:
          cancelBookingKelasState ?? this.cancelBookingKelasState,
    );
  }
}
