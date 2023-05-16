import 'dart:convert';

import 'package:mobile_gofit/Model/sesi_gym.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadSesiGym implements Exception {
  final String message;

  FailedToLoadSesiGym(this.message);
}

class SesiGymRepository {
  Future<List<SesiGym>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}sesiGym/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<SesiGym> sesiGym =
          data.map((e) => SesiGym.createSesiGym(e)).toList();
      return sesiGym;
    } else {
      throw FailedToLoadSesiGym('Failed to load sesi Gym');
    }
  }
}
