abstract class HistoryMemberBookingGymEvent {}

class HistoryMemberBookinGymFetchedRequested
    extends HistoryMemberBookingGymEvent {}

class CancelBookingGymRequested extends HistoryMemberBookingGymEvent {
  String id;
  CancelBookingGymRequested({required this.id});
}

class HistoryMemberBookingGymDateChanged extends HistoryMemberBookingGymEvent {
  final String startDate;
  final String endDate;
  HistoryMemberBookingGymDateChanged(
      {required this.startDate, required this.endDate});
}
