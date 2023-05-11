import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/IzinInstrukturTambahBloc/izin_instruktur_tambah_event.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/IzinInstrukturTambahBloc/izin_instruktur_tambah_state.dart';
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Repository/instruktur_repository.dart';
import 'package:mobile_gofit/Repository/izin_instruktur_repository.dart';
import 'package:mobile_gofit/Repository/jadwal_umum_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../../Model/jadwal_umum.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturTambahBloc
    extends Bloc<IzinInstrukturTambahEvent, IzinInstrukturTambahState> {
  final IzinInstrukturRepository izinInstrukturRepository;
  final JadwalUmumRepository jadwalUmumRepository;
  final InstrukturRepository instrukturRepository;

  IzinInstrukturTambahBloc(
      {required this.izinInstrukturRepository,
      required this.jadwalUmumRepository,
      required this.instrukturRepository})
      : super(IzinInstrukturTambahState()) {
    on<IzinInstrukturPageFetchedRequested>(
        (event, emit) => _onIzinInstrukturPageFetchedRequested(event, emit));
    on<IzinInstrukturTambahJadwalUmumFetchData>((event, emit) =>
        _onIzinInstrukturTambahJadwalUmumFetchData(event, emit));
    on<IzinInstrukturTanggalIzinFormChanged>(
        (event, emit) => _onIzinInstrukturTanggalIzinFormChanged(event, emit));
    on<IzinInstrukturFormChanged>(
        (event, emit) => _onIzinInstrukturFormChanged(event, emit));
    on<IzinInstrukturFormSubmitted>(
        (event, emit) => _onIzinInstrukturFormSubmitted(event, emit));
  }
  void _onIzinInstrukturPageFetchedRequested(
      IzinInstrukturPageFetchedRequested event,
      Emitter<IzinInstrukturTambahState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
      jadwalUmumListFetchedDataState: const InitialPageFetchedDataState(),
      formSubmissionState: const InitialFormState(),
    ));
    try {
      List<Instruktur> instrukturList =
          await instrukturRepository.getFiltered();
      instrukturList.insert(0, Instruktur.empty);
      emit(state.copyWith(
        instrukturList: instrukturList,
        pageFetchedDataState: PageFetchedDataSuccess(instrukturList),
      ));
    } on FailedToLoadInstruktur catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }

  void _onIzinInstrukturTambahJadwalUmumFetchData(
      IzinInstrukturTambahJadwalUmumFetchData event,
      Emitter<IzinInstrukturTambahState> emit) async {
    emit(state.copyWith(
      jadwalUmumListFetchedDataState: PageFetchedDataLoading(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      formSubmissionState: const InitialFormState(),
    ));
    try {
      List<JadwalUmum> listJadwalUmum = await jadwalUmumRepository
          .getThisDay(state.izinInstrukturForm.tanggalIzin);
      listJadwalUmum.insert(0, JadwalUmum.empty);
      emit(state.copyWith(
        jadwalUmumList: listJadwalUmum,
        jadwalUmumListFetchedDataState: PageFetchedDataSuccess(listJadwalUmum),
        isSelectJadwalUmumEnabled: true,
      ));
    } on FailedToLoadJadwalUmum catch (e) {
      emit(state.copyWith(
        jadwalUmumListFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }

  void _onIzinInstrukturTanggalIzinFormChanged(
      IzinInstrukturTanggalIzinFormChanged event,
      Emitter<IzinInstrukturTambahState> emit) {
    emit(state.copyWith(
      izinInstrukturForm: state.izinInstrukturForm.copyWith(
        tanggalIzin: event.tanggalIzinForm,
      ),
      jadwalUmumListFetchedDataState: const InitialPageFetchedDataState(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      formSubmissionState: const InitialFormState(),
    ));
    add(IzinInstrukturTambahJadwalUmumFetchData());
  }

  void _onIzinInstrukturFormChanged(IzinInstrukturFormChanged event,
      Emitter<IzinInstrukturTambahState> emit) {
    emit(state.copyWith(
      izinInstrukturForm: event.izinInstrukturForm,
      jadwalUmumListFetchedDataState: const InitialPageFetchedDataState(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      formSubmissionState: const InitialFormState(),
    ));
  }

  void _onIzinInstrukturFormSubmitted(IzinInstrukturFormSubmitted event,
      Emitter<IzinInstrukturTambahState> emit) async {
    emit(state.copyWith(
      formSubmissionState: FormSubmitting(),
      jadwalUmumListFetchedDataState: const InitialPageFetchedDataState(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
    ));
    try {
      await izinInstrukturRepository.add(state.izinInstrukturForm);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on ErrorValidatedIzinInstruktur catch (e) {
      emit(state.copyWith(izinInstrukturError: e.izinInstruktur));
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
