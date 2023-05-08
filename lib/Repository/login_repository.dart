import 'package:http/http.dart' as http;
import 'package:mobile_gofit/Model/instruktur.dart';

import 'dart:convert';
import '../Model/member.dart';
import '../Model/user.dart';
import '../const.dart';
import '../Model/pegawai.dart';
import '../token_bearer.dart';

class LogInWithUsernamePasswordFailure implements Exception {
  final Map<String, String> message;

  LogInWithUsernamePasswordFailure(this.message);

  @override
  String toString() {
    return '${message['username']} ${message['password']}';
  }
}

class LogInWithFailure implements Exception {
  final String message;

  LogInWithFailure(this.message);
}

class LogOutWithFailure implements Exception {
  final String message;

  LogOutWithFailure(this.message);
}

class TokenFailure implements Exception {
  final String message;

  TokenFailure(this.message);
}

class GetUserFailure implements Exception {
  final String message;

  GetUserFailure(this.message);
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}

class LoginRepository {
  Future<void> login(String username, String password) async {
    var url = Uri.parse('${uri}loginMobile');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      //sukses, simpan token
      var token = json.decode(response.body)['data'];
      TokenBearer().save(token);
    } else if (response.statusCode == 400) {
      //username atau password kosong
      String usernameError = '';
      String passwordError = '';
      final decoded = json.decode(response.body)['data'];
      if (decoded.containsKey('username')) {
        usernameError = decoded['username'][0];
      }
      if (decoded.containsKey('password')) {
        passwordError = decoded['password'][0];
      }
      var msg = {
        'username': usernameError.toString(),
        'password': passwordError.toString(),
      };
      throw LogInWithUsernamePasswordFailure(msg);
    } else if (response.statusCode == 401) {
      //akun tidak ditemukan
      throw LogInWithFailure('Username or password is incorrect');
    } else {
      throw HttpException(
          'There is something wrong with the server or connection');
    }
  }

  Future<void> logout() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}logout');
    var response =
        await http.post(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      //sukses, hapus token
      TokenBearer().remove();
    } else {
      //terjadi kesalahan
      throw LogOutWithFailure(
          'There is something wrong with the server or connection');
    }
  }

  Future<User> getUser() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}getUserMobile');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      var role = json.decode(response.body)['role'];
      if (role == 'member') {
        return User(user: Member.createMember(data), role: 0);
      }
      if (role == 'instruktur') {
        return User(user: Instruktur.createInstruktur(data), role: 1);
      }
      return User(user: Pegawai.createPegawai(data), role: 2);
    } else {
      throw GetUserFailure(
          'There is something wrong with the server or connection');
    }
  }
}
