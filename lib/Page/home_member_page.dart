import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../Asset/card_jadwal_harian.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/HomeMemberBloc/home_member_bloc.dart';
import '../Bloc/HomeMemberBloc/home_member_event.dart';
import '../Bloc/HomeMemberBloc/home_member_state.dart';
import '../Model/member.dart';
import '../const.dart';

class HomeMemberPage extends StatelessWidget {
  const HomeMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeMemberBloc>(
      create: (context) {
        return HomeMemberBloc(jadwalHarianRepository: JadwalHarianRepository());
      },
      child: const HomeMemberView(),
    );
  }
}

class HomeMemberView extends StatefulWidget {
  const HomeMemberView({super.key});

  @override
  State<HomeMemberView> createState() => _HomeMemberViewState();
}

class _HomeMemberViewState extends State<HomeMemberView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeMemberBloc>().add(HomeMemberDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeMemberBloc, HomeMemberState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
      },
      child: BlocBuilder<HomeMemberBloc, HomeMemberState>(
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
                              'Halo, ${(context.read<AppBloc>().state.user.user as Member).username}!',
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
                            (context.read<AppBloc>().state.user.user as Member)
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
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: primaryColor,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.queue,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8.0),
                            const Text('Tambah booking'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Temukan',
                      style: TextStyle(
                        color: accentColor,
                        fontFamily: 'roboto',
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Kelasmu Minggu ini',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const ListJadwalHarianCard(),
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
    return BlocBuilder<HomeMemberBloc, HomeMemberState>(
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
                        onPressed: () {
                          context.push('/booking-kelas', extra: item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Text(
                            "Booking",
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
