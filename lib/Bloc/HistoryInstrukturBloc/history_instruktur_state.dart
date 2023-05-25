import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../Model/jadwal_harian.dart';

class HistoryInstrukturState {
  final List<JadwalHarian> jadwalHarian;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState formSubmissionState;
  final String bulanSelected;
  final String tahunSelected;
  final String bulanError;
  final String tahunError;

  HistoryInstrukturState({
    this.jadwalHarian = const <JadwalHarian>[],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.formSubmissionState = const InitialFormState(),
    this.bulanSelected = '',
    this.tahunSelected = '',
    this.bulanError = '',
    this.tahunError = '',
  });

  HistoryInstrukturState copyWith({
    List<JadwalHarian>? jadwalHarian,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? formSubmissionState,
    String? bulanSelected,
    String? tahunSelected,
    String? bulanError,
    String? tahunError,
  }) {
    return HistoryInstrukturState(
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      bulanSelected: bulanSelected ?? this.bulanSelected,
      tahunSelected: tahunSelected ?? this.tahunSelected,
      bulanError: bulanError ?? this.bulanError,
      tahunError: tahunError ?? this.tahunError,
    );
  }
}
