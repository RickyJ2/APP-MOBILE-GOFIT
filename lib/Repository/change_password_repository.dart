import 'dart:convert';
import 'dart:io';

import '../const.dart';
import '../token_bearer.dart';
import 'package:http/http.dart' as http;

class ChangePasswordFormFailure implements Exception {
  final Map<String, String> message;

  ChangePasswordFormFailure(this.message);

  @override
  String toString() {
    return '${message['old_password']} ${message['new_password']}';
  }
}

class ChangePasswordFailure implements Exception {
  final String message;

  ChangePasswordFailure(this.message);
}

class ChangePasswordRepository {
  Future<void> changePasswordInstruktur(
      String oldPassword, String newPassword) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/ubahPassword');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'password': oldPassword,
      'password_baru': newPassword,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      var decoded = jsonDecode(response.body)['data'];
      String oldPasswordError = '';
      String newPasswordError = '';
      if (decoded.containsKey('password')) {
        oldPasswordError = decoded['password'][0];
      }
      if (decoded.containsKey('password_baru')) {
        newPasswordError = decoded['password_baru'][0];
      }
      throw ChangePasswordFormFailure({
        'old_password': oldPasswordError,
        'new_password': newPasswordError,
      });
    } else {
      throw const HttpException('Gagal menghubungi server');
    }
  }

  Future<void> changePasswordMO(String oldPassword, String newPassword) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}pegawai/ubahPassword');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'password': oldPassword,
      'password_baru': newPassword,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      var decoded = jsonDecode(response.body)['data'];
      String oldPasswordError = '';
      String newPasswordError = '';
      if (decoded.containsKey('password')) {
        oldPasswordError = decoded['password'][0];
      }
      if (decoded.containsKey('password_baru')) {
        newPasswordError = decoded['password_baru'][0];
      }
      throw ChangePasswordFormFailure({
        'old_password': oldPasswordError,
        'new_password': newPasswordError,
      });
    } else {
      throw const HttpException('Gagal menghubungi server');
    }
  }
}
