import 'package:equatable/equatable.dart';

import 'instruktur.dart';
import 'jadwal_umum.dart';
import 'kelas.dart';

class JadwalHarian extends Equatable {
  final String id;
  final JadwalUmum jadwalUmum;
  final String tanggal;
  final String status;
  final String instrukturPenganti;
  final int count;
  final String jamMulai;
  final String jamSelesai;

  JadwalHarian copyWith({
    String? id,
    JadwalUmum? jadwalUmum,
    String? tanggal,
    String? status,
    String? instrukturPenganti,
    int? count,
    String? jamMulai,
    String? jamSelesai,
  }) {
    return JadwalHarian(
      id: id ?? this.id,
      jadwalUmum: jadwalUmum ?? this.jadwalUmum,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      instrukturPenganti: instrukturPenganti ?? this.instrukturPenganti,
      count: count ?? this.count,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
    );
  }

  const JadwalHarian({
    this.id = '',
    this.jadwalUmum = const JadwalUmum(),
    this.tanggal = '',
    this.status = '',
    this.instrukturPenganti = '',
    this.count = 0,
    this.jamMulai = '',
    this.jamSelesai = '',
  });

  factory JadwalHarian.createJadwalHarian(Map<String, dynamic> object) {
    return JadwalHarian(
      id: object['id'].toString(),
      jadwalUmum: JadwalUmum(
        kelas: Kelas(
          nama: object['nama_kelas'].toString(),
          harga: object['harga_kelas'].toString(),
        ),
        instruktur: Instruktur(
          nama: object['nama_instruktur'].toString(),
        ),
        jamMulai: object['jam_mulai_kelas'].toString(),
        hari: object['hari'].toString(),
      ),
      tanggal: object['tanggal'].toString(),
      status: object['jenis_status'],
      instrukturPenganti: object['instruktur_penganti'],
      count: object['total_bookings'],
      jamMulai: object['jam_mulai'] ?? '',
      jamSelesai: object['jam_selesai'] ?? '',
    );
  }

  static const empty = JadwalHarian(
    id: '',
    jadwalUmum: JadwalUmum.empty,
    tanggal: '',
    status: '',
    instrukturPenganti: '',
    count: 0,
    jamMulai: '',
    jamSelesai: '',
  );

  bool get isEmpty => this == JadwalHarian.empty;
  bool get isNoEmpty => this != JadwalHarian.empty;

  @override
  List<Object> get props => [
        id,
        jadwalUmum,
        tanggal,
        status,
        instrukturPenganti,
        count,
        jamMulai,
        jamSelesai,
      ];
}
