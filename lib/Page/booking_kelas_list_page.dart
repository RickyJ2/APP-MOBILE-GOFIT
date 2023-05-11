import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasListBloc/booking_kelas_list_bloc.dart';
import 'package:mobile_gofit/Bloc/BookingKelasGymBloc/BookingKelasListBloc/booking_kelas_list_state.dart';
import 'package:mobile_gofit/Repository/jadwal_harian_repository.dart';

import '../Asset/card_jadwal_harian.dart';
import '../Bloc/BookingKelasGymBloc/BookingKelasListBloc/booking_kelas_list_event.dart';
import '../const.dart';

class BookingKelasListPage extends StatelessWidget {
  const BookingKelasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingKelasListBloc>(
      create: (context) {
        return BookingKelasListBloc(
            jadwalHarianRepository: JadwalHarianRepository());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Pilih Kelas"),
            foregroundColor: textColor,
          ),
          body: const SingleChildScrollView(child: BookingKelasListView()),
        ),
      ),
    );
  }
}

class BookingKelasListView extends StatefulWidget {
  const BookingKelasListView({super.key});

  @override
  State<BookingKelasListView> createState() => _BookingKelasListViewState();
}

class _BookingKelasListViewState extends State<BookingKelasListView> {
  @override
  void initState() {
    super.initState();
    context.read<BookingKelasListBloc>().add(BookingKelasListDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingKelasListBloc, BookingKelasListState>(
        builder: (context, state) {
      return Column(
          children: state.jadwalHarian
              .map(
                (item) => TextButton(
                  onPressed: () {
                    Navigator.pop(context, item);
                  },
                  child: CardJadwalHarian(
                    jadwalHarian: item,
                  ),
                ),
              )
              .toList());
    });
  }
}
