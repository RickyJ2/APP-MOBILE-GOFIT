import 'package:mobile_gofit/Model/izin_instruktur.dart';

abstract class IzinInstrukturTambahEvent {}

class IzinInstrukturTambahJadwalUmumFetchData
    extends IzinInstrukturTambahEvent {}

class IzinInstrukturTanggalIzinFormChanged extends IzinInstrukturTambahEvent {
  final String tanggalIzinForm;
  IzinInstrukturTanggalIzinFormChanged({required this.tanggalIzinForm});
}

class IzinInstrukturPageFetchedRequested extends IzinInstrukturTambahEvent {}

class IzinInstrukturFormChanged extends IzinInstrukturTambahEvent {
  final IzinInstruktur izinInstrukturForm;
  IzinInstrukturFormChanged({required this.izinInstrukturForm});
}

class IzinInstrukturFormSubmitted extends IzinInstrukturTambahEvent {}
