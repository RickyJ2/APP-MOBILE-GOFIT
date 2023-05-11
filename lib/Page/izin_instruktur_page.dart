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
                      : SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 24.0,
                            ),
                            child: const ListIzinInstrukturCard(),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}

class ListIzinInstrukturCard extends StatelessWidget {
  const ListIzinInstrukturCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IzinInstrukturBloc, IzinInstrukturState>(
      builder: (context, state) {
        return Column(
          children: state.izinInstrukturList
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.kelas.nama,
                            style: const TextStyle(
                              fontFamily: 'SchibstedGrotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          item.isConfirmed == 2
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.green),
                                  child: const Text('Disetujui',
                                      style: TextStyle(color: Colors.white)))
                              : item.isConfirmed == 1
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.red),
                                      child: const Text('Ditolak',
                                          style:
                                              TextStyle(color: Colors.white)))
                                  : Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: neutralYellowColor),
                                      child: const Text('Menunggu',
                                          style:
                                              TextStyle(color: Colors.white))),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                        child: Divider(
                          color: primaryColor,
                          thickness: 3.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, color: primaryColor),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "${item.jadwalUmum.hari}, ${item.tanggalIzin} ${item.jadwalUmum.jamMulai}",
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.person, color: primaryColor),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Digantikan oleh ${item.instrukturPenganti.nama}',
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Diajukan pada ${item.tanggalMengajukan}",
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
