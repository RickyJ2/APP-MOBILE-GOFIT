import 'package:mobile_gofit/Model/booking_kelas.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HistoryMemberBookingKelasState {
  final List<BookingKelas> bookingKelasList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState cancelBookingKelasState;
  final String startDate;
  final String endDate;

  HistoryMemberBookingKelasState({
    this.bookingKelasList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.cancelBookingKelasState = const InitialFormState(),
    this.startDate = "",
    this.endDate = "",
  });

  HistoryMemberBookingKelasState copyWith({
    List<BookingKelas>? bookingKelasList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? cancelBookingKelasState,
    String? startDate,
    String? endDate,
  }) {
    return HistoryMemberBookingKelasState(
      bookingKelasList: bookingKelasList ?? this.bookingKelasList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      cancelBookingKelasState:
          cancelBookingKelasState ?? this.cancelBookingKelasState,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
