abstract class HistoryMemberBookingGymEvent {}

class HistoryMemberBookinGymFetchedRequested
    extends HistoryMemberBookingGymEvent {}

class CancelBookingGymRequested extends HistoryMemberBookingGymEvent {
  String id;
  CancelBookingGymRequested({required this.id});
}
