import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Model/booking_kelas.dart';
import '../const.dart';
import '../token_bearer.dart';

class ErrorValidateFromBookingKelas implements Exception {
  final BookingKelas bookingKelas;

  ErrorValidateFromBookingKelas(this.bookingKelas);

  @override
  String toString() {
    return bookingKelas.jadwalHarian.id;
  }
}

class FailedToLoadBookingKelas implements Exception {
  final String message;

  FailedToLoadBookingKelas(this.message);
}

class BookingKelasRepository {
  Future<List<BookingKelas>> show() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingKelas/show');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<BookingKelas> bookingKelas =
          data.map((e) => BookingKelas.createBookingKelas(e)).toList();
      return bookingKelas;
    } else {
      throw const HttpException('Failed to load Booking');
    }
  }

  Future<void> add(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingKelas/add');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'jadwal_harian_id': id,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw FailedToLoadBookingKelas(json.decode(response.body)['message']);
    } else {
      throw const HttpException('Failed to add Booking');
    }
  }

  Future<void> cancel(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingKelas/cancel');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'id': id,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw FailedToLoadBookingKelas(json.decode(response.body)['message']);
    } else {
      throw const HttpException('Failed to cancel Booking');
    }
  }
}
