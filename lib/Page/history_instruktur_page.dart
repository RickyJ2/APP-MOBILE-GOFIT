import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Asset/create_drop_down_button.dart';
import 'package:mobile_gofit/Bloc/HistoryInstrukturBloc/history_instruktur_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryInstrukturBloc/history_instruktur_event.dart';
import 'package:mobile_gofit/Bloc/HistoryInstrukturBloc/history_instruktur_state.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../Asset/thousands_formater.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class HistoryInstrukturPage extends StatelessWidget {
  const HistoryInstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryInstrukturBloc>(
      create: (context) => HistoryInstrukturBloc(
          jadwalHarianRepository: JadwalHarianRepository()),
      child: const HistoryInstrukturView(),
    );
  }
}

class HistoryInstrukturView extends StatefulWidget {
  const HistoryInstrukturView({super.key});

  @override
  State<HistoryInstrukturView> createState() => _HistoryInstrukturViewState();
}

class _HistoryInstrukturViewState extends State<HistoryInstrukturView> {
  @override
  void initState() {
    super.initState();
    context
        .read<HistoryInstrukturBloc>()
        .add(HistoryInstrukturPageFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryInstrukturBloc, HistoryInstrukturState>(
      listener: ((context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception),
            ),
          );
        }
      }),
      child: BlocBuilder<HistoryInstrukturBloc, HistoryInstrukturState>(
          builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CreateDropDownButton(
                    label: "Bulan",
                    errorText: state.bulanError == '' ? null : state.bulanError,
                    value: state.bulanSelected,
                    items: bulan
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: state.jadwalHarian.isEmpty &&
                            state.bulanSelected == '' &&
                            state.tahunSelected == ''
                        ? null
                        : (value) {
                            context.read<HistoryInstrukturBloc>().add(
                                HistoryInstrukturBulanChanged(
                                    bulan: value.toString()));
                          },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CreateDropDownButton(
                    label: "Tahun",
                    errorText: state.tahunError == '' ? null : state.tahunError,
                    value: state.tahunSelected,
                    items: yearList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: state.jadwalHarian.isEmpty &&
                            state.bulanSelected == '' &&
                            state.tahunSelected == ''
                        ? null
                        : (value) {
                            context.read<HistoryInstrukturBloc>().add(
                                HistoryInstrukturTahunChanged(
                                    tahun: value.toString()));
                          },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: state.jadwalHarian.isEmpty &&
                          state.bulanSelected == '' &&
                          state.tahunSelected == ''
                      ? null
                      : () {
                          context
                              .read<HistoryInstrukturBloc>()
                              .add(HistoryInstrukturFormSubmitted());
                        },
                  child: Text(
                    'Filter',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            state.pageFetchedDataState is PageFetchedDataLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.jadwalHarian.isEmpty
                    ? const Center(
                        child: Text('Instruktur belum ada aktivitas'),
                      )
                    : const ListAktivitasInstrukturCard(),
          ],
        );
      }),
    );
  }
}

class ListAktivitasInstrukturCard extends StatelessWidget {
  const ListAktivitasInstrukturCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryInstrukturBloc, HistoryInstrukturState>(
      builder: (context, state) {
        return Column(
          children: state.jadwalHarian
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
                      Text(
                        item.jadwalUmum.kelas.nama,
                        style: const TextStyle(
                          fontFamily: 'SchibstedGrotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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
                            "${item.jadwalUmum.hari}, ${item.tanggal}",
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Icon(Icons.schedule, color: primaryColor),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            item.jadwalUmum.jamMulai,
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Icon(Icons.person, color: primaryColor),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            item.instrukturPenganti.isEmpty
                                ? item.jadwalUmum.instruktur.nama
                                : '${item.instrukturPenganti} (Mengantikan ${item.jadwalUmum.instruktur.nama})',
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.payments, color: primaryColor),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "Rp ${ThousandsFormatterString.format(item.jadwalUmum.kelas.harga)}",
                                style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.people, color: primaryColor),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "${item.count} of 10",
                                style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      item.jamMulai != '' && item.jamSelesai != ''
                          ? Text(
                              "Kelas dimulai ${item.jamMulai} dan berakhir ${item.jamSelesai}",
                              style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.normal),
                            )
                          : Container(),
                      const SizedBox(height: 5.0),
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
