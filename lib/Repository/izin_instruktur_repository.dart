import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Model/jadwal_umum.dart';

import '../Model/izin_instruktur.dart';
import '../const.dart';
import '../token_bearer.dart';

class ErrorValidatedIzinInstruktur implements Exception {
  final IzinInstruktur izinInstruktur;

  ErrorValidatedIzinInstruktur(this.izinInstruktur);

  @override
  String toString() {
    return '${izinInstruktur.jadwalUmum.id} ${izinInstruktur.instrukturPenganti.id} ${izinInstruktur.tanggalIzin} ${izinInstruktur.keterangan}';
  }
}

class FailedToLoadIizinInstruktur implements Exception {
  final String message;

  FailedToLoadIizinInstruktur(this.message);
}

class IzinInstrukturRepository {
  Future<List<IzinInstruktur>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}izinInstruktur/show');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<IzinInstruktur> izinInstruktur =
          data.map((e) => IzinInstruktur.createIzinInstruktur(e)).toList();
      return izinInstruktur;
    } else {
      throw FailedToLoadIizinInstruktur('Failed to load Izin Instruktur');
    }
  }

  Future<void> add(IzinInstruktur izinInstruktur) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}izinInstruktur/add');
    var response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'jadwal_umum_id': izinInstruktur.jadwalUmum.id.toString(),
        'instruktur_penganti_id':
            izinInstruktur.instrukturPenganti.id.toString(),
        'tanggal_izin': izinInstruktur.tanggalIzin.toString(),
        'keterangan': izinInstruktur.keterangan,
      },
    );
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      IzinInstruktur izinInstrukturError = const IzinInstruktur();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('jadwal_umum_id')) {
        izinInstrukturError = izinInstrukturError.copyWith(
            jadwalUmum: JadwalUmum(
          id: decoded['jadwal_umum_id'][0],
        ));
      }
      if (decoded.containsKey('instruktur_penganti_id')) {
        izinInstrukturError = izinInstrukturError.copyWith(
            instrukturPenganti: Instruktur(
          id: decoded['instruktur_penganti_id'][0],
        ));
      }
      if (decoded.containsKey('tanggal_izin')) {
        izinInstrukturError = izinInstrukturError.copyWith(
          tanggalIzin: decoded['tanggal_izin'][0],
        );
      }
      if (decoded.containsKey('keterangan')) {
        izinInstrukturError = izinInstrukturError.copyWith(
          keterangan: decoded['keterangan'][0],
        );
      }
      throw ErrorValidatedIzinInstruktur(izinInstrukturError);
    } else {
      throw const HttpException('Failed to add izin Instruktur');
    }
  }
}
