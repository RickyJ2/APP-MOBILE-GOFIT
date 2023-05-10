import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HomeMemberBloc/home_member_event.dart';
import 'package:mobile_gofit/Bloc/HomeMemberBloc/home_member_state.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../../Model/jadwal_harian.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class HomeMemberBloc extends Bloc<HomeMemberEvent, HomeMemberState> {
  final JadwalHarianRepository jadwalHarianRepository;
  HomeMemberBloc({required this.jadwalHarianRepository})
      : super(HomeMemberState()) {
    on<HomeMemberDataFetched>(
        (event, emit) => _onHomeMemberDataFetched(event, emit));
  }

  void _onHomeMemberDataFetched(
      HomeMemberDataFetched event, Emitter<HomeMemberState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      List<JadwalHarian> listJadwalHarian = await jadwalHarianRepository.get();
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
