import 'package:mobile_gofit/Model/booking_gym.dart';

abstract class BookingGymEvent {}

class BookingGymPageDataRequested extends BookingGymEvent {}

class BookingGymFormChanged extends BookingGymEvent {
  final BookingGym bookingGym;
  BookingGymFormChanged({required this.bookingGym});
}

class BookingGymFormSubmitted extends BookingGymEvent {}
