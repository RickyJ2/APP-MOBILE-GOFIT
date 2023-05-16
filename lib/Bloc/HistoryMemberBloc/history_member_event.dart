abstract class HistoryMemberEvent {}

class HistoryMemberToogleChanged extends HistoryMemberEvent {
  final int toogleState;
  HistoryMemberToogleChanged({required this.toogleState});
}
