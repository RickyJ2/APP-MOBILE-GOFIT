abstract class HistoryMemberBookingKelasEvent {}

class HistoryMemberPageFetchedRequested
    extends HistoryMemberBookingKelasEvent {}

class CancelBookingKelasRequested extends HistoryMemberBookingKelasEvent {
  String id;
  CancelBookingKelasRequested({required this.id});
}
