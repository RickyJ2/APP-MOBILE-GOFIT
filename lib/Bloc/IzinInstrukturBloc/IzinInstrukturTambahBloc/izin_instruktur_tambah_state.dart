import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Model/izin_instruktur.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import '../../../Model/jadwal_umum.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturTambahState {
  final IzinInstruktur izinInstrukturForm;
  final IzinInstruktur izinInstrukturError;
  final List<Instruktur> instrukturList;
  final List<JadwalUmum> jadwalUmumList;
  final PageFetchedDataState pageFetchedDataState;
  final PageFetchedDataState jadwalUmumListFetchedDataState;
  final FormSubmissionState formSubmissionState;
  final bool isSelectJadwalUmumEnabled;

  IzinInstrukturTambahState({
    this.izinInstrukturForm = const IzinInstruktur(),
    this.izinInstrukturError = const IzinInstruktur(),
    this.instrukturList = const [],
    this.jadwalUmumList = const [JadwalUmum.empty],
    this.jadwalUmumListFetchedDataState = const InitialPageFetchedDataState(),
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.formSubmissionState = const InitialFormState(),
    this.isSelectJadwalUmumEnabled = false,
  });

  IzinInstrukturTambahState copyWith({
    IzinInstruktur? izinInstrukturForm,
    IzinInstruktur? izinInstrukturError,
    List<Instruktur>? instrukturList,
    List<JadwalUmum>? jadwalUmumList,
    PageFetchedDataState? jadwalUmumListFetchedDataState,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? formSubmissionState,
    bool? isSelectJadwalUmumEnabled,
  }) {
    return IzinInstrukturTambahState(
      izinInstrukturForm: izinInstrukturForm ?? this.izinInstrukturForm,
      izinInstrukturError: izinInstrukturError ?? this.izinInstrukturError,
      instrukturList: instrukturList ?? this.instrukturList,
      jadwalUmumList: jadwalUmumList ?? this.jadwalUmumList,
      jadwalUmumListFetchedDataState:
          jadwalUmumListFetchedDataState ?? this.jadwalUmumListFetchedDataState,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      isSelectJadwalUmumEnabled:
          isSelectJadwalUmumEnabled ?? this.isSelectJadwalUmumEnabled,
    );
  }
}
