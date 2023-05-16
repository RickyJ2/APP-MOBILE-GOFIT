import 'package:equatable/equatable.dart';

class Instruktur extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelp;
  final String username;
  final String? password;
  final int? akumulasiTerlambat;

  Instruktur copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? tglLahir,
    String? noTelp,
    String? username,
    String? password,
    int? akumulasiTerlambat,
  }) {
    return Instruktur(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      tglLahir: tglLahir ?? this.tglLahir,
      noTelp: noTelp ?? this.noTelp,
      username: username ?? this.username,
      password: password ?? this.password,
      akumulasiTerlambat: akumulasiTerlambat ?? this.akumulasiTerlambat,
    );
  }

  const Instruktur({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.tglLahir = '',
    this.noTelp = '',
    this.username = '',
    this.password = '',
    this.akumulasiTerlambat = 0,
  });

  factory Instruktur.createInstruktur(Map<String, dynamic> object) {
    return Instruktur(
        id: object['id'].toString(),
        nama: object['nama'].toString(),
        alamat: object['alamat'].toString(),
        tglLahir: object['tgl_lahir'].toString(),
        noTelp: object['no_telp'].toString(),
        username: object['username'].toString(),
        akumulasiTerlambat: object['akumulasi_terlambat']);
  }

  static const empty = Instruktur(
    id: '',
    nama: '',
    alamat: '',
    tglLahir: '',
    noTelp: '',
    username: '',
    password: '',
    akumulasiTerlambat: 0,
  );

  bool get isEmpty => this == Instruktur.empty;
  bool get isNoEmpty => this != Instruktur.empty;

  @override
  List<Object?> get props =>
      [id, nama, alamat, tglLahir, noTelp, username, akumulasiTerlambat];
}
