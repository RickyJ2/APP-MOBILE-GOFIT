abstract class ListMemberBookingKelasEvent {}

class ListMemberBookingKelasPageFetchedRequested
    extends ListMemberBookingKelasEvent {
  String id;
  ListMemberBookingKelasPageFetchedRequested({required this.id});
}

class PresentBookingKelasChanged extends ListMemberBookingKelasEvent {
  String present;
  int index;
  PresentBookingKelasChanged({required this.present, required this.index});
}

class PresentBookingKelasRequested extends ListMemberBookingKelasEvent {
  String id;
  PresentBookingKelasRequested({required this.id});
}
