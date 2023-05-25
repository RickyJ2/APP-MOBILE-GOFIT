abstract class HistoryInstrukturEvent {}

class HistoryInstrukturPageFetchRequested extends HistoryInstrukturEvent {}

class HistoryInstrukturBulanChanged extends HistoryInstrukturEvent {
  final String bulan;

  HistoryInstrukturBulanChanged({required this.bulan});
}

class HistoryInstrukturTahunChanged extends HistoryInstrukturEvent {
  final String tahun;

  HistoryInstrukturTahunChanged({required this.tahun});
}

class HistoryInstrukturFormSubmitted extends HistoryInstrukturEvent {}
