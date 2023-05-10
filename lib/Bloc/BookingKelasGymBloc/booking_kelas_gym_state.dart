class BookingKelasGymState {
  final List<bool> toogleState;

  BookingKelasGymState({
    this.toogleState = const [true, false],
  });

  BookingKelasGymState copyWith({
    List<bool>? toogleState,
  }) {
    return BookingKelasGymState(
      toogleState: toogleState ?? this.toogleState,
    );
  }
}
