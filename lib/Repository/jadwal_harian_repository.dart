import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_gofit/Model/jadwal_harian.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadJadwalHarian implements Exception {
  final String message;

  FailedToLoadJadwalHarian(this.message);
}

class JadwalHarianRepository {
  Future<List<JadwalHarian>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/indexThisWeek');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<JadwalHarian> jadwalHarian =
          data.map((e) => JadwalHarian.createJadwalHarian(e)).toList();
      return jadwalHarian;
    } else {
      throw FailedToLoadJadwalHarian('Failed to load jadwal harian');
    }
  }

  Future<List<JadwalHarian>> getToday() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/showToday');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<JadwalHarian> jadwalHarian =
          data.map((e) => JadwalHarian.createJadwalHarian(e)).toList();
      return jadwalHarian;
    } else {
      throw FailedToLoadJadwalHarian('Failed to load jadwal harian');
    }
  }

  Future<List<JadwalHarian>> getTodaySchedule() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/showTodaySchedule');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<JadwalHarian> jadwalHarian =
          data.map((e) => JadwalHarian.createJadwalHarian(e)).toList();
      return jadwalHarian;
    } else {
      throw FailedToLoadJadwalHarian('Failed to load jadwal harian');
    }
  }

  Future<void> updateJamMulai(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/updateJamMulai/$id');
    var response =
        await http.put(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw FailedToLoadJadwalHarian('Failed to update jadwal harian');
    }
  }

  Future<void> updateJamSelesai(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/updateJamSelesai/$id');
    var response =
        await http.put(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw FailedToLoadJadwalHarian('Failed to update jadwal harian');
    }
  }
}
