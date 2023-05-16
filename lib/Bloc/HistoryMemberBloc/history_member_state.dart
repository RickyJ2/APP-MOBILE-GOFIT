class HistoryMemberState {
  final List<bool> toggleState;

  const HistoryMemberState({
    this.toggleState = const [true, false],
  });

  HistoryMemberState copyWith({
    List<bool>? toggleState,
  }) {
    return HistoryMemberState(
      toggleState: toggleState ?? this.toggleState,
    );
  }
}
