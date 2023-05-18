import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/ListMemberBookingKelasBloc/list_member_booking_kelas_event.dart';
import 'package:mobile_gofit/Bloc/ListMemberBookingKelasBloc/list_member_booking_kelas_state.dart';
import 'package:mobile_gofit/Model/booking_kelas.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class ListMemberBookingKelasBloc
    extends Bloc<ListMemberBookingKelasEvent, ListMemberBookingKelasState> {
  final BookingKelasRepository bookingKelasRepository;

  ListMemberBookingKelasBloc({required this.bookingKelasRepository})
      : super(ListMemberBookingKelasState()) {
    on<ListMemberBookingKelasPageFetchedRequested>((event, emit) =>
        _onListMemberBookingKelasPageFetchedRequested(event, emit));
    on<PresentBookingKelasChanged>(
        (event, emit) => _onPresentBookingKelasChanged(event, emit));
    on<PresentBookingKelasRequested>(
        (event, emit) => _onPresentBookingKelasRequested(event, emit));
  }

  void _onListMemberBookingKelasPageFetchedRequested(
      ListMemberBookingKelasPageFetchedRequested event,
      Emitter<ListMemberBookingKelasState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        presentFormSubmissionState: const InitialFormState()));
    try {
      List<BookingKelas> bookingKelasList =
          await bookingKelasRepository.getListMember(event.id);
      emit(state.copyWith(
        bookingKelasList: bookingKelasList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingKelasList),
      ));
    } on FailedToLoadBookingKelas catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.message)));
    }
  }

  void _onPresentBookingKelasChanged(PresentBookingKelasChanged event,
      Emitter<ListMemberBookingKelasState> emit) async {
    List<BookingKelas> bookingKelasList = state.bookingKelasList;
    bookingKelasList[event.index] = bookingKelasList[event.index]
        .copyWith(presentAt: event.present == 'Hadir' ? '1' : '');
    emit(state.copyWith(
        presentFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        bookingKelasList: bookingKelasList));
  }

  void _onPresentBookingKelasRequested(PresentBookingKelasRequested event,
      Emitter<ListMemberBookingKelasState> emit) async {
    emit(
      state.copyWith(
        presentFormSubmissionState: FormSubmitting(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
      ),
    );
    try {
      await bookingKelasRepository.present(state.bookingKelasList);
      emit(state.copyWith(presentFormSubmissionState: SubmissionSuccess()));
    } on FailedToLoadBookingKelas catch (e) {
      emit(state.copyWith(
          presentFormSubmissionState: SubmissionFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(
          presentFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
