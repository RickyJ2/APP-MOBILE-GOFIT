import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../Asset/card_jadwal_harian.dart';
import '../Asset/confirmation_dialog.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/HomeMOBloc/home_mo_bloc.dart';
import '../Bloc/HomeMOBloc/home_mo_event.dart';
import '../Bloc/HomeMOBloc/home_mo_state.dart';
import '../Model/pegawai.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class HomeMOPage extends StatelessWidget {
  const HomeMOPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeMOBloc>(
      create: (context) {
        return HomeMOBloc(jadwalHarianRepository: JadwalHarianRepository());
      },
      child: const HomeMOView(),
    );
  }
}

class HomeMOView extends StatefulWidget {
  const HomeMOView({super.key});

  @override
  State<HomeMOView> createState() => _HomeMOViewState();
}

class _HomeMOViewState extends State<HomeMOView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeMOBloc>().add(HomeMODataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeMOBloc, HomeMOState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
        if (state.jamMulaiUpdateRequestState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Jam mulai berhasil diupdate')));
          context.read<HomeMOBloc>().add(HomeMODataFetched());
        }
        if (state.jamSelesaiUpdateRequestState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Jam selesai berhasil diupdate')));
          context.read<HomeMOBloc>().add(HomeMODataFetched());
        }
        if (state.jamMulaiUpdateRequestState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.jamMulaiUpdateRequestState as SubmissionFailed)
                      .exception)));
        }
        if (state.jamSelesaiUpdateRequestState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.jamSelesaiUpdateRequestState as SubmissionFailed)
                      .exception)));
        }
      },
      child: BlocBuilder<HomeMOBloc, HomeMOState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${(context.read<AppBloc>().state.user.user as Pegawai).username}!',
                              style: TextStyle(
                                color: accentColor,
                                fontFamily: 'roboto',
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, dd MMMM', 'id')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                color: accentColor,
                                fontFamily: 'roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 15,
                          child: Text(
                            (context.read<AppBloc>().state.user.user as Pegawai)
                                .username[0],
                            style: TextStyle(
                                fontFamily: 'SchibstedGrotesk',
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Kelas Hari ini',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    state.jadwalHarian.isEmpty
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Tidak kelas hari ini'),
                          ))
                        : const ListJadwalHarianCard(),
                  ],
                );
        },
      ),
    );
  }
}

class ListJadwalHarianCard extends StatelessWidget {
  const ListJadwalHarianCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMOBloc, HomeMOState>(builder: (context, state) {
      return Column(
          children: state.jadwalHarian
              .map(
                (item) => CardJadwalHarian(
                  jadwalHarian: item,
                  action: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, color: primaryColor),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            '${item.jamMulai == '' ? '--:--' : item.jamMulai} s/d ${item.jamSelesai == '' ? '--:--' : item.jamSelesai}',
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: item.jamMulai != ''
                                ? null
                                : () {
                                    void jamMulai() {
                                      BlocProvider.of<HomeMOBloc>(context).add(
                                          HomeMOJamMulaiUpdateRequested(
                                              id: item.id));
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        title: 'Update Jam Mulai Kelas',
                                        message:
                                            'Apakah anda yakin ingin mengupdate Jam Mulai kelas ${item.jadwalUmum.kelas.nama}?',
                                        onYes: () {
                                          Navigator.pop(context);
                                          jamMulai();
                                        },
                                      ),
                                    );
                                  },
                            child: Text(
                              "Jam Mulai",
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          ElevatedButton(
                            onPressed: item.jamMulai == '' ||
                                    item.jamSelesai != ''
                                ? null
                                : () {
                                    void jamSelesai() {
                                      BlocProvider.of<HomeMOBloc>(context).add(
                                          HomeMOJamSelesaiUpdateRequested(
                                              id: item.id));
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        title: 'Update Jam Selesai Kelas',
                                        message:
                                            'Apakah anda yakin ingin mengupdate Jam Selesai kelas ${item.jadwalUmum.kelas.nama}?',
                                        onYes: () {
                                          Navigator.pop(context);
                                          jamSelesai();
                                        },
                                      ),
                                    );
                                  },
                            child: Text(
                              "Jam Selesai",
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList());
    });
  }
}
