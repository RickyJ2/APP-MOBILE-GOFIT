import 'package:mobile_gofit/Model/jadwal_umum.dart';

import '../../Model/jadwal_umum_formated.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class JadwalUmumState {
  final List<JadwalUmumFormated> jadwalUmumList;
  final List<JadwalUmum> jadwalUmumDisplay;
  final PageFetchedDataState pageFetchedDataState;
  final String dropDownDay;

  JadwalUmumState({
    this.jadwalUmumList = const [],
    this.jadwalUmumDisplay = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.dropDownDay = "Monday",
  });

  JadwalUmumState copyWith({
    List<JadwalUmumFormated>? jadwalUmumList,
    List<JadwalUmum>? jadwalUmumDisplay,
    PageFetchedDataState? pageFetchedDataState,
    String? dropDownDay,
  }) {
    return JadwalUmumState(
      jadwalUmumList: jadwalUmumList ?? this.jadwalUmumList,
      jadwalUmumDisplay: jadwalUmumDisplay ?? this.jadwalUmumDisplay,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      dropDownDay: dropDownDay ?? this.dropDownDay,
    );
  }
}
