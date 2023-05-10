import '../../../Model/jadwal_harian.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';

class BookingKelasListState {
  final List<JadwalHarian> jadwalHarian;
  final PageFetchedDataState pageFetchedDataState;

  BookingKelasListState({
    this.jadwalHarian = const <JadwalHarian>[],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
  });

  BookingKelasListState copyWith({
    List<JadwalHarian>? jadwalHarian,
    PageFetchedDataState? pageFetchedDataState,
  }) {
    return BookingKelasListState(
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
    );
  }
}
