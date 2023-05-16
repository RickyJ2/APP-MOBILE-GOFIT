import 'package:mobile_gofit/Model/booking_gym.dart';
import 'package:mobile_gofit/Model/sesi_gym.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../../StateBlocTemplate/form_submission_state.dart';

class BookingGymState {
  final List<SesiGym> listSesiGym;
  final BookingGym bookingGymForm;
  final BookingGym bookingGymError;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState formSubmissionState;

  BookingGymState({
    this.listSesiGym = const [],
    this.bookingGymForm = const BookingGym(),
    this.bookingGymError = const BookingGym(),
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.formSubmissionState = const InitialFormState(),
  });

  BookingGymState copyWith({
    List<SesiGym>? listSesiGym,
    BookingGym? bookingGymForm,
    BookingGym? bookingGymError,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? formSubmissionState,
  }) {
    return BookingGymState(
      listSesiGym: listSesiGym ?? this.listSesiGym,
      bookingGymForm: bookingGymForm ?? this.bookingGymForm,
      bookingGymError: bookingGymError ?? this.bookingGymError,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
