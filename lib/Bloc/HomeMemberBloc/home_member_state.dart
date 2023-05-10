import '../../Model/jadwal_harian.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class HomeMemberState {
  final List<JadwalHarian> jadwalHarian;
  final PageFetchedDataState pageFetchedDataState;

  HomeMemberState({
    this.jadwalHarian = const <JadwalHarian>[],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
  });
  HomeMemberState copyWith(
      {List<JadwalHarian>? jadwalHarian,
      PageFetchedDataState? pageFetchedDataState}) {
    return HomeMemberState(
        jadwalHarian: jadwalHarian ?? this.jadwalHarian,
        pageFetchedDataState:
            pageFetchedDataState ?? this.pageFetchedDataState);
  }
}
