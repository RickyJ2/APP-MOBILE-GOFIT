import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../StateBlocTemplate/page_fetched_data_state.dart';

class HomeMOState {
  final List<JadwalHarian> jadwalHarian;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState jamMulaiUpdateRequestState;
  final FormSubmissionState jamSelesaiUpdateRequestState;

  HomeMOState({
    this.jadwalHarian = const <JadwalHarian>[],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.jamMulaiUpdateRequestState = const InitialFormState(),
    this.jamSelesaiUpdateRequestState = const InitialFormState(),
  });

  HomeMOState copyWith({
    List<JadwalHarian>? jadwalHarian,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? jamMulaiUpdateRequestState,
    FormSubmissionState? jamSelesaiUpdateRequestState,
  }) {
    return HomeMOState(
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      jamMulaiUpdateRequestState:
          jamMulaiUpdateRequestState ?? this.jamMulaiUpdateRequestState,
      jamSelesaiUpdateRequestState:
          jamSelesaiUpdateRequestState ?? this.jamSelesaiUpdateRequestState,
    );
  }
}
