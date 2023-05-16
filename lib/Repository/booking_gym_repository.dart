import 'dart:convert';
import 'dart:io';

import 'package:mobile_gofit/Model/booking_gym.dart';

import 'package:http/http.dart' as http;
import '../const.dart';
import '../token_bearer.dart';

class ErrorValidateFromBookingGym implements Exception {
  final BookingGym bookingGym;

  ErrorValidateFromBookingGym(this.bookingGym);

  @override
  String toString() {
    return '${bookingGym.tanggal.toString()} ${bookingGym.sesiGym.id.toString()}';
  }
}

class FailedToLoadBookingGym implements Exception {
  final String message;

  FailedToLoadBookingGym(this.message);
}

class BookingGymRepository {
  Future<List<BookingGym>> show() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingGym/show');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<BookingGym> bookingKelas =
          data.map((e) => BookingGym.createBookingGym(e)).toList();
      return bookingKelas;
    } else {
      throw const HttpException('Failed to load Booking');
    }
  }

  Future<void> add(BookingGym bookingGym) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingGym/add');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'sesi_gym_id': bookingGym.sesiGym.id.toString(),
      'tgl_booking': bookingGym.tanggal.toString(),
    });

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      BookingGym bookingGym = const BookingGym();
      final decoded = json.decode(response.body)['message'];
      if (decoded.containesKey('sesi_gym_id')) {
        bookingGym = bookingGym.copyWith(
            sesiGym: bookingGym.sesiGym
                .copyWith(id: decoded['sesi_gym_id'][0].toString()));
      }
      if (decoded.containesKey('tgl_booking')) {
        bookingGym =
            bookingGym.copyWith(tanggal: decoded['tgl_booking'][0].toString());
      }
      throw ErrorValidateFromBookingGym(bookingGym);
    } else if (response.statusCode == 401) {
      throw FailedToLoadBookingGym(json.decode(response.body)['message']);
    } else {
      throw const HttpException('Failed to add Booking');
    }
  }

  Future<void> cancel(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingGym/cancel');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'id': id,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw FailedToLoadBookingGym(json.decode(response.body)['message']);
    } else {
      throw const HttpException('Failed to cancel Booking');
    }
  }
}
