abstract class JadwalUmumEvent {}

class JadwalUmumDataFetched extends JadwalUmumEvent {}

class DropDownDayChanged extends JadwalUmumEvent {
  final String day;

  DropDownDayChanged({required this.day});
}
