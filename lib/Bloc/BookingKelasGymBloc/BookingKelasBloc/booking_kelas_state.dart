import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../../Model/jadwal_harian.dart';

class BookingKelasState {
  final JadwalHarian jadwalHarian;
  final FormSubmissionState formSubmissionState;

  BookingKelasState({
    this.jadwalHarian = JadwalHarian.empty,
    this.formSubmissionState = const InitialFormState(),
  });

  BookingKelasState copyWith({
    JadwalHarian? jadwalHarian,
    FormSubmissionState? formSubmissionState,
  }) {
    return BookingKelasState(
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
