import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_event.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_state.dart';
import 'package:mobile_gofit/Repository/izin_instruktur_repository.dart';

import '../../Model/izin_instruktur.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturBloc
    extends Bloc<IzinInstrukturEvent, IzinInstrukturState> {
  final IzinInstrukturRepository izinInstrukturRepository;

  IzinInstrukturBloc({required this.izinInstrukturRepository})
      : super(IzinInstrukturState()) {
    on<IzinInstrukturFetchData>(
        (event, emit) => _onIzinInstrukturFetchData(event, emit));
  }

  void _onIzinInstrukturFetchData(
      IzinInstrukturFetchData event, Emitter<IzinInstrukturState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      List<IzinInstruktur> listIzinInstruktur =
          await izinInstrukturRepository.get();
      emit(state.copyWith(
        izinInstrukturList: listIzinInstruktur,
        pageFetchedDataState: PageFetchedDataSuccess(listIzinInstruktur),
      ));
    } on FailedToLoadIizinInstruktur catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message),
      ));
    }
  }
}
