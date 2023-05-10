abstract class BookingKelasGymEvent {}

class BookingKelasGymToogleChanged extends BookingKelasGymEvent {
  final int toogleState;
  BookingKelasGymToogleChanged({required this.toogleState});
}
