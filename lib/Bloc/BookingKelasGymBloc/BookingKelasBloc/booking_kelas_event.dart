import 'package:mobile_gofit/Model/jadwal_harian.dart';

abstract class BookingKelasEvent {}

class BookingKelasJadwalHarianChanged extends BookingKelasEvent {
  final JadwalHarian jadwalHarian;
  BookingKelasJadwalHarianChanged({required this.jadwalHarian});
}

class BookingKelasFormSubmitted extends BookingKelasEvent {}
