abstract class HistoryMemberBookingKelasEvent {}

class HistoryMemberPageFetchedRequested
    extends HistoryMemberBookingKelasEvent {}

class CancelBookingKelasRequested extends HistoryMemberBookingKelasEvent {
  String id;
  CancelBookingKelasRequested({required this.id});
}

class HistoryMemberBookingKelasDateChanged
    extends HistoryMemberBookingKelasEvent {
  final String startDate;
  final String endDate;
  HistoryMemberBookingKelasDateChanged(
      {required this.startDate, required this.endDate});
}
