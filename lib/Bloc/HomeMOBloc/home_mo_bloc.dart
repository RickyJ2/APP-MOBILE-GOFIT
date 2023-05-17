import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HomeMOBloc/home_mo_event.dart';
import 'package:mobile_gofit/Bloc/HomeMOBloc/home_mo_state.dart';
import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HomeMOBloc extends Bloc<HomeMOEvent, HomeMOState> {
  final JadwalHarianRepository jadwalHarianRepository;

  HomeMOBloc({required this.jadwalHarianRepository}) : super(HomeMOState()) {
    on<HomeMODataFetched>((event, emit) => _onHomeMODataFetched(event, emit));
    on<HomeMOJamMulaiUpdateRequested>(
        (event, emit) => _onHomeMOJamMulaiUpdateRequested(event, emit));
    on<HomeMOJamSelesaiUpdateRequested>(
        (event, emit) => _onHomeMOJamSelesaiUpdateRequested(event, emit));
  }

  void _onHomeMODataFetched(
      HomeMODataFetched event, Emitter<HomeMOState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
      jamMulaiUpdateRequestState: const InitialFormState(),
      jamSelesaiUpdateRequestState: const InitialFormState(),
    ));
    try {
      List<JadwalHarian> jadwalHarian = await jadwalHarianRepository.getToday();
      emit(state.copyWith(
          jadwalHarian: jadwalHarian,
          pageFetchedDataState: PageFetchedDataSuccess(jadwalHarian)));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }

  void _onHomeMOJamMulaiUpdateRequested(
      HomeMOJamMulaiUpdateRequested event, Emitter<HomeMOState> emit) async {
    emit(state.copyWith(
      jamMulaiUpdateRequestState: FormSubmitting(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      jamSelesaiUpdateRequestState: const InitialFormState(),
    ));
    try {
      await jadwalHarianRepository.updateJamMulai(event.id);
      emit(state.copyWith(
        jamMulaiUpdateRequestState: SubmissionSuccess(),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
        jamMulaiUpdateRequestState: SubmissionFailed(e.message),
      ));
    }
  }

  void _onHomeMOJamSelesaiUpdateRequested(
      HomeMOJamSelesaiUpdateRequested event, Emitter<HomeMOState> emit) async {
    emit(state.copyWith(
      jamSelesaiUpdateRequestState: FormSubmitting(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      jamMulaiUpdateRequestState: const InitialFormState(),
    ));
    try {
      await jadwalHarianRepository.updateJamSelesai(event.id);
      emit(state.copyWith(
        jamSelesaiUpdateRequestState: SubmissionSuccess(),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
        jamSelesaiUpdateRequestState: SubmissionFailed(e.message),
      ));
    }
  }
}
