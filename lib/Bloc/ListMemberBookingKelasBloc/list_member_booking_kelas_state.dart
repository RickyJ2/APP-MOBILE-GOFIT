import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../Model/booking_kelas.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class ListMemberBookingKelasState {
  final List<BookingKelas> bookingKelasList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState presentFormSubmissionState;

  ListMemberBookingKelasState({
    this.bookingKelasList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.presentFormSubmissionState = const InitialFormState(),
  });

  ListMemberBookingKelasState copyWith({
    List<BookingKelas>? bookingKelasList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? presentFormSubmissionState,
  }) {
    return ListMemberBookingKelasState(
      bookingKelasList: bookingKelasList ?? this.bookingKelasList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      presentFormSubmissionState:
          presentFormSubmissionState ?? this.presentFormSubmissionState,
    );
  }
}
