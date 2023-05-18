import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_gofit/Bloc/HomeInstrukturBloc/home_instruktur_bloc.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../Asset/card_jadwal_harian.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/HomeInstrukturBloc/home_instruktur_event.dart';
import '../Bloc/HomeInstrukturBloc/home_instruktur_state.dart';
import '../Model/instruktur.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class HomeInstrukturPage extends StatelessWidget {
  const HomeInstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeInstrukturBloc>(
      create: (context) {
        return HomeInstrukturBloc(
            jadwalHarianRepository: JadwalHarianRepository());
      },
      child: const HomeInstrukturView(),
    );
  }
}

class HomeInstrukturView extends StatefulWidget {
  const HomeInstrukturView({super.key});

  @override
  State<HomeInstrukturView> createState() => _HomeInstrukturViewState();
}

class _HomeInstrukturViewState extends State<HomeInstrukturView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeInstrukturBloc>().add(HomeInstrukturDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeInstrukturBloc, HomeInstrukturState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
      },
      child: BlocBuilder<HomeInstrukturBloc, HomeInstrukturState>(
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
                              'Halo, ${(context.read<AppBloc>().state.user.user as Instruktur).username}!',
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
                            (context.read<AppBloc>().state.user.user
                                    as Instruktur)
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
                      'Jadwal Instruktur hari ini',
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
                            child: Text('Belum ada jadwal kelas hari ini'),
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
    return BlocBuilder<HomeInstrukturBloc, HomeInstrukturState>(
        builder: (context, state) {
      return Column(
          children: state.jadwalHarian
              .map(
                (item) => CardJadwalHarian(
                  jadwalHarian: item,
                  action: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: item.jamMulai == ''
                            ? null
                            : () {
                                context.push('/list-member-booking-kelas',
                                    extra: item.id);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Text(
                            "Presensi",
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList());
    });
  }
}
