import 'package:mobile_gofit/Model/izin_instruktur.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturState {
  final List<IzinInstruktur> izinInstrukturList;
  final PageFetchedDataState pageFetchedDataState;

  IzinInstrukturState({
    this.izinInstrukturList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
  });

  IzinInstrukturState copyWith({
    List<IzinInstruktur>? izinInstrukturList,
    PageFetchedDataState? pageFetchedDataState,
  }) {
    return IzinInstrukturState(
      izinInstrukturList: izinInstrukturList ?? this.izinInstrukturList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
    );
  }
}
