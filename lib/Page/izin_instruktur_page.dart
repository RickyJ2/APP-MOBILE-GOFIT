import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_state.dart';
import 'package:mobile_gofit/Repository/izin_instruktur_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';
import 'package:mobile_gofit/const.dart';

import '../Bloc/IzinInstrukturBloc/izin_instruktur_bloc.dart';
import '../Bloc/IzinInstrukturBloc/izin_instruktur_event.dart';

class IzinInstrukturPage extends StatelessWidget {
  const IzinInstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IzinInstrukturBloc>(
      create: (context) => IzinInstrukturBloc(
          izinInstrukturRepository: IzinInstrukturRepository()),
      child: const IzinInstrukturView(),
    );
  }
}

class IzinInstrukturView extends StatefulWidget {
  const IzinInstrukturView({super.key});

  @override
  State<IzinInstrukturView> createState() => _IzinInstrukturViewState();
}

class _IzinInstrukturViewState extends State<IzinInstrukturView> {
  @override
  void initState() {
    super.initState();
    context.read<IzinInstrukturBloc>().add(IzinInstrukturFetchData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IzinInstrukturBloc, IzinInstrukturState>(
      listenWhen: (previous, current) =>
          previous.pageFetchedDataState != current.pageFetchedDataState,
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception),
            ),
          );
        }
      },
      child: BlocBuilder<IzinInstrukturBloc, IzinInstrukturState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: textColor,
                title: const Text("Izin Instruktur"),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.push('/izin-instruktur/tambah');
                },
                backgroundColor: primaryColor,
                foregroundColor: textColor,
                child: const Icon(Icons.add),
              ),
              body: state.pageFetchedDataState is PageFetchedDataLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.izinInstrukturList.isEmpty
                      ? const Center(
                          child: Text('Izin Instruktur masih kosong'),
                        )
                      : Container(),
            ),
          );
        },
      ),
    );
  }
}
