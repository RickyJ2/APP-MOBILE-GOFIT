import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasListBloc/booking_kelas_list_event.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasListBloc/booking_kelas_list_state.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../../../Model/jadwal_harian.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';

class BookingKelasListBloc
    extends Bloc<BookingKelasListEvent, BookingKelasListState> {
  final JadwalHarianRepository jadwalHarianRepository;

  BookingKelasListBloc({required this.jadwalHarianRepository})
      : super(BookingKelasListState()) {
    on<BookingKelasListDataFetched>(
        (event, emit) => _onBookingKelasListDataFetched(event, emit));
  }

  void _onBookingKelasListDataFetched(BookingKelasListDataFetched event,
      Emitter<BookingKelasListState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      List<JadwalHarian> listJadwalHarian = await jadwalHarianRepository.get();
      emit(state.copyWith(
        jadwalHarian: listJadwalHarian,
        pageFetchedDataState: PageFetchedDataSuccess(listJadwalHarian),
      ));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }
}
