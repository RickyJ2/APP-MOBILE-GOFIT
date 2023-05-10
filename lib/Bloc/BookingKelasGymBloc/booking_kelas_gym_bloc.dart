import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_kelas_gym_event.dart';
import 'booking_kelas_gym_state.dart';

class BookingKelasGymBloc
    extends Bloc<BookingKelasGymEvent, BookingKelasGymState> {
  BookingKelasGymBloc() : super(BookingKelasGymState()) {
    on<BookingKelasGymToogleChanged>(
        (event, emit) => _onBookingKelasGymToogleChanged(event, emit));
  }

  void _onBookingKelasGymToogleChanged(
      BookingKelasGymToogleChanged event, Emitter<BookingKelasGymState> emit) {
    if (event.toogleState == 0) {
      emit(state.copyWith(toogleState: [true, false]));
    } else {
      emit(state.copyWith(toogleState: [false, true]));
    }
  }
}
