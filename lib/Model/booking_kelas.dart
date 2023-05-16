import 'package:equatable/equatable.dart';
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Model/jadwal_umum.dart';
import 'package:mobile_gofit/Model/kelas.dart';

import 'jadwal_harian.dart';
import 'member.dart';

class BookingKelas extends Equatable {
  final String id;
  final String noStruk;
  final Member member;
  final JadwalHarian jadwalHarian;
  final bool isCanceled;
  final bool isPresent;
  final String createdAt;

  BookingKelas copyWith({
    String? id,
    String? noStruk,
    Member? member,
    JadwalHarian? jadwalHarian,
    bool? isCanceled,
    bool? isPresent,
    String? createdAt,
  }) {
    return BookingKelas(
      id: id ?? this.id,
      noStruk: noStruk ?? this.noStruk,
      member: member ?? this.member,
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      isCanceled: isCanceled ?? this.isCanceled,
      isPresent: isPresent ?? this.isPresent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  const BookingKelas({
    this.id = '',
    this.noStruk = '',
    this.member = const Member(),
    this.jadwalHarian = const JadwalHarian(),
    this.isPresent = false,
    this.isCanceled = false,
    this.createdAt = '',
  });

  factory BookingKelas.createBookingKelas(Map<String, dynamic> object) {
    return BookingKelas(
      id: object['id'].toString(),
      noStruk: object['no_nota'].toString(),
      member: Member(
        id: object['member_id'].toString(),
      ),
      jadwalHarian: JadwalHarian(
        id: object['jadwal_harian_id'].toString(),
        tanggal: object['tanggal'].toString(),
        status: object['jenis_status'],
        instrukturPenganti: object['instruktur_penganti'],
        jadwalUmum: JadwalUmum(
          hari: object['hari'].toString(),
          jamMulai: object['jam_mulai'].toString(),
          instruktur: Instruktur(
            nama: object['nama_instruktur'].toString(),
          ),
          kelas: Kelas(
            nama: object['nama_kelas'].toString(),
            harga: object['harga_kelas'].toString(),
          ),
        ),
      ),
      isPresent: object['is_present'].toString() == '1' ? true : false,
      isCanceled: object['is_cancelled'].toString() == '1' ? true : false,
      createdAt: object['created_at'].toString(),
    );
  }

  static const empty = BookingKelas();

  bool get isEmpty => this == BookingKelas.empty;
  bool get isNotEmpty => this != BookingKelas.empty;

  @override
  List<Object?> get props => [
        id,
        noStruk,
        member,
        jadwalHarian,
        isPresent,
        isCanceled,
        createdAt,
      ];
}
