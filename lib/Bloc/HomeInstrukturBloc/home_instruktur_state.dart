import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class HomeInstrukturState {
  final List<JadwalHarian> jadwalHarian;
  final PageFetchedDataState pageFetchedDataState;

  HomeInstrukturState({
    this.jadwalHarian = const <JadwalHarian>[],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
  });

  HomeInstrukturState copyWith(
      {List<JadwalHarian>? jadwalHarian,
      PageFetchedDataState? pageFetchedDataState}) {
    return HomeInstrukturState(
        jadwalHarian: jadwalHarian ?? this.jadwalHarian,
        pageFetchedDataState:
            pageFetchedDataState ?? this.pageFetchedDataState);
  }
}
