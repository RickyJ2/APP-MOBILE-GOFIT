import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryInstrukturBloc/history_instruktur_state.dart';
import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import 'history_instruktur_event.dart';

class HistoryInstrukturBloc
    extends Bloc<HistoryInstrukturEvent, HistoryInstrukturState> {
  final JadwalHarianRepository jadwalHarianRepository;

  HistoryInstrukturBloc({required this.jadwalHarianRepository})
      : super(HistoryInstrukturState()) {
    on<HistoryInstrukturPageFetchRequested>(
        (event, emit) => _onHistoryInstrukturPageFetchRequested(event, emit));
    on<HistoryInstrukturBulanChanged>(
        (event, emit) => _onHistoryInstrukturBulanChanged(event, emit));
    on<HistoryInstrukturTahunChanged>(
        (event, emit) => _onHistoryInstrukturTahunChanged(event, emit));
    on<HistoryInstrukturFormSubmitted>(
        (event, emit) => _onHistoryInstrukturFormSubmitted(event, emit));
  }

  void _onHistoryInstrukturPageFetchRequested(
      HistoryInstrukturPageFetchRequested event,
      Emitter<HistoryInstrukturState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      List<JadwalHarian> jadwalHarianList = await jadwalHarianRepository.show();
      emit(state.copyWith(
        jadwalHarian: jadwalHarianList,
        pageFetchedDataState: PageFetchedDataSuccess(jadwalHarianList),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onHistoryInstrukturBulanChanged(HistoryInstrukturBulanChanged event,
      Emitter<HistoryInstrukturState> emit) {
    emit(state.copyWith(bulanSelected: event.bulan));
  }

  void _onHistoryInstrukturTahunChanged(HistoryInstrukturTahunChanged event,
      Emitter<HistoryInstrukturState> emit) {
    emit(state.copyWith(tahunSelected: event.tahun));
  }

  void _onHistoryInstrukturFormSubmitted(HistoryInstrukturFormSubmitted event,
      Emitter<HistoryInstrukturState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    if (state.bulanSelected == '') {
      emit(state.copyWith(bulanError: 'Bulan tidak boleh kosong'));
    }
    if (state.tahunSelected == '') {
      emit(state.copyWith(tahunError: 'Tahun tidak boleh kosong'));
    }
    try {
      List<JadwalHarian> jadwalHarianList = await jadwalHarianRepository
          .showFilter(state.tahunSelected, state.bulanSelected);
      emit(state.copyWith(
        jadwalHarian: jadwalHarianList,
        pageFetchedDataState: PageFetchedDataSuccess(jadwalHarianList),
        formSubmissionState: SubmissionSuccess(),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }
}
