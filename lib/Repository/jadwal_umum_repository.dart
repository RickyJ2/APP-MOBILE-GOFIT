import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/jadwal_umum.dart';
import '../Model/jadwal_umum_formated.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadJadwalUmum implements Exception {
  final String message;

  FailedToLoadJadwalUmum(this.message);
}

class JadwalUmumRepository {
  Future<List<JadwalUmumFormated>> get() async {
    var url = Uri.parse('${uri}jadwalUmum/index');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as Map<String, dynamic>;
      List<JadwalUmumFormated> jadwalUmum = [];
      data.forEach((key, value) {
        jadwalUmum.add(JadwalUmumFormated.createJadwalUmumFormated(key, value));
      });
      return jadwalUmum;
    } else {
      throw FailedToLoadJadwalUmum('Failed to load jadwal umum');
    }
  }

  Future<List<JadwalUmum>> getThisDay(String date) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalUmum/getThisDay');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'tanggal_izin': date,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<JadwalUmum> jadwalUmum =
          data.map((e) => JadwalUmum.createJadwalUmum(e)).toList();
      return jadwalUmum;
    } else {
      throw FailedToLoadJadwalUmum('Failed to load jadwal umum');
    }
  }
}
