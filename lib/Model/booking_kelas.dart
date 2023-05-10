import 'package:equatable/equatable.dart';

import 'jadwal_harian.dart';
import 'member.dart';

class BookingKelas extends Equatable {
  final String id;
  final String noStruk;
  final Member member;
  final JadwalHarian jadwalHarian;
  final bool isCanceled;

  BookingKelas copyWith({
    String? id,
    String? noStruk,
    Member? member,
    JadwalHarian? jadwalHarian,
    bool? isCanceled,
  }) {
    return BookingKelas(
      id: id ?? this.id,
      noStruk: noStruk ?? this.noStruk,
      member: member ?? this.member,
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      isCanceled: isCanceled ?? this.isCanceled,
    );
  }

  const BookingKelas({
    this.id = '',
    this.noStruk = '',
    this.member = const Member(),
    this.jadwalHarian = const JadwalHarian(),
    this.isCanceled = false,
  });

  factory BookingKelas.createMember(Map<String, dynamic> object) {
    return BookingKelas(
      id: object['id'],
      noStruk: object['no_struk'],
      member: Member.createMember(object['member']),
      jadwalHarian: JadwalHarian.createJadwalHarian(object['jadwal_harian']),
      isCanceled: object['is_canceled'],
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
        isCanceled,
      ];
}
