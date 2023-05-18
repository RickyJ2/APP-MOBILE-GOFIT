import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/jadwal_umum_repository.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';
import 'jadwal_umum_event.dart';
import 'jadwal_umum_state.dart';

class JadwalUmumBloc extends Bloc<JadwalUmumEvent, JadwalUmumState> {
  final JadwalUmumRepository jadwalUmumRepository;

  JadwalUmumBloc({required this.jadwalUmumRepository})
      : super(JadwalUmumState()) {
    on<JadwalUmumDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<DropDownDayChanged>((event, emit) => _onDropDownDayChanged(event, emit));
  }

  void _onDataFetched(
      JadwalUmumDataFetched event, Emitter<JadwalUmumState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      final jadwalUmumList = await jadwalUmumRepository.get();
      emit(state.copyWith(
          jadwalUmumList: jadwalUmumList,
          jadwalUmumDisplay: jadwalUmumList[0].jadwalUmumList,
          pageFetchedDataState: PageFetchedDataSuccess(jadwalUmumList)));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onDropDownDayChanged(
      DropDownDayChanged event, Emitter<JadwalUmumState> emit) {
    emit(state.copyWith(
        dropDownDay: event.day,
        jadwalUmumDisplay: state.jadwalUmumList
            .where((element) => element.hari == event.day)
            .toList()[0]
            .jadwalUmumList));
  }
}
