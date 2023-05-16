import 'package:equatable/equatable.dart';
import 'package:mobile_gofit/Model/member.dart';
import 'package:mobile_gofit/Model/sesi_gym.dart';

class BookingGym extends Equatable {
  final String id;
  final String noStruk;
  final Member member;
  final String tanggal;
  final SesiGym sesiGym;
  final bool isCanceled;
  final bool isPresent;
  final String createdAt;

  BookingGym copyWith({
    String? id,
    String? noStruk,
    Member? member,
    String? tanggal,
    SesiGym? sesiGym,
    bool? isCanceled,
    bool? isPresent,
    String? createdAt,
  }) {
    return BookingGym(
      id: id ?? this.id,
      noStruk: noStruk ?? this.noStruk,
      member: member ?? this.member,
      tanggal: tanggal ?? this.tanggal,
      sesiGym: sesiGym ?? this.sesiGym,
      isCanceled: isCanceled ?? this.isCanceled,
      isPresent: isPresent ?? this.isPresent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  const BookingGym({
    this.id = '',
    this.noStruk = '',
    this.member = const Member(),
    this.tanggal = '',
    this.sesiGym = SesiGym.empty,
    this.isPresent = false,
    this.isCanceled = false,
    this.createdAt = '',
  });

  factory BookingGym.createBookingGym(Map<String, dynamic> object) {
    return BookingGym(
      id: object['id'].toString(),
      noStruk: object['no_nota'].toString(),
      member: Member(
        id: object['member_id'].toString(),
      ),
      tanggal: object['tgl_booking'].toString(),
      sesiGym: SesiGym(
        id: object['sesi_gym_id'].toString(),
        jamMulai: object['jam_mulai'].toString(),
        jamSelesai: object['jam_selesai'].toString(),
      ),
      isPresent: object['is_present'].toString() == '1' ? true : false,
      isCanceled: object['is_cancelled'].toString() == '1' ? true : false,
      createdAt: object['created_at'].toString(),
    );
  }

  static const empty = BookingGym();
  bool get isEmpty => this == BookingGym.empty;
  bool get isNotEmpty => this != BookingGym.empty;

  @override
  List<Object?> get props => [
        id,
        noStruk,
        member,
        tanggal,
        sesiGym,
        isCanceled,
        isPresent,
        createdAt,
      ];
}
