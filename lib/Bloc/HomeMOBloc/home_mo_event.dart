abstract class HomeMOEvent {}

class HomeMODataFetched extends HomeMOEvent {}

class HomeMOJamMulaiUpdateRequested extends HomeMOEvent {
  final String id;

  HomeMOJamMulaiUpdateRequested({required this.id});
}

class HomeMOJamSelesaiUpdateRequested extends HomeMOEvent {
  final String id;

  HomeMOJamSelesaiUpdateRequested({required this.id});
}
