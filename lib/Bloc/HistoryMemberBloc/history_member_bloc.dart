import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/history_member_event.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/history_member_state.dart';

class HistoryMemberBloc extends Bloc<HistoryMemberEvent, HistoryMemberState> {
  HistoryMemberBloc() : super(const HistoryMemberState()) {
    on<HistoryMemberToogleChanged>(
        (event, emit) => _onHistoryMemberToogleChanged(event, emit));
  }

  void _onHistoryMemberToogleChanged(
      HistoryMemberToogleChanged event, Emitter<HistoryMemberState> emit) {
    emit(state.copyWith(
      toggleState: [
        event.toogleState == 0 ? true : false,
        event.toogleState == 1 ? true : false,
      ],
    ));
  }
}
