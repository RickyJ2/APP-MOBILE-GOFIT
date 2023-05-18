import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HomeInstrukturBloc/home_instruktur_event.dart';
import 'package:mobile_gofit/Bloc/HomeInstrukturBloc/home_instruktur_state.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../../Model/jadwal_harian.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class HomeInstrukturBloc
    extends Bloc<HomeInstrukturEvent, HomeInstrukturState> {
  final JadwalHarianRepository jadwalHarianRepository;
  HomeInstrukturBloc({required this.jadwalHarianRepository})
      : super(HomeInstrukturState()) {
    on<HomeInstrukturDataFetched>(
        (event, emit) => _onHomeInstrukturDataFetched(event, emit));
  }

  void _onHomeInstrukturDataFetched(HomeInstrukturDataFetched event,
      Emitter<HomeInstrukturState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      List<JadwalHarian> listJadwalHarian =
          await jadwalHarianRepository.getTodaySchedule();
      emit(state.copyWith(
        jadwalHarian: listJadwalHarian,
        pageFetchedDataState: PageFetchedDataSuccess(listJadwalHarian),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }
}
