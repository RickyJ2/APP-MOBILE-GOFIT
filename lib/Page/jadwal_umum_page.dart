import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Asset/create_drop_down_button.dart';
import 'package:mobile_gofit/Bloc/JadwalUmumBloc/jadwal_umum_bloc.dart';
import 'package:mobile_gofit/Bloc/JadwalUmumBloc/jadwal_umum_state.dart';
import 'package:mobile_gofit/Repository/jadwal_umum_repository.dart';

import '../Asset/thousands_formater.dart';
import '../Bloc/JadwalUmumBloc/jadwal_umum_event.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class JadwalUmumPage extends StatelessWidget {
  const JadwalUmumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text("Jadwal Umum"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: JadwalUmumPageView(),
      )),
    ));
  }
}

class JadwalUmumPageView extends StatelessWidget {
  const JadwalUmumPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JadwalUmumBloc>(
        create: (context) =>
            JadwalUmumBloc(jadwalUmumRepository: JadwalUmumRepository()),
        child: const JadwalUmumView());
  }
}

class JadwalUmumView extends StatefulWidget {
  const JadwalUmumView({super.key});

  @override
  State<JadwalUmumView> createState() => _JadwalUmumViewState();
}

class _JadwalUmumViewState extends State<JadwalUmumView> {
  @override
  void initState() {
    super.initState();
    context.read<JadwalUmumBloc>().add(JadwalUmumDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JadwalUmumBloc, JadwalUmumState>(
        listener: (context, state) {
      if (state.pageFetchedDataState is PageFetchedDataFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((state.pageFetchedDataState as PageFetchedDataFailed)
                .exception),
          ),
        );
      }
    }, child: BlocBuilder<JadwalUmumBloc, JadwalUmumState>(
      builder: (context, state) {
        return state.pageFetchedDataState is PageFetchedDataLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Hari'),
                  const SizedBox(height: 8),
                  CreateDropDownButton(
                    value: state.dropDownDay,
                    items: day
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        )
                        .toList(),
                    onChanged: (value) {
                      context
                          .read<JadwalUmumBloc>()
                          .add(DropDownDayChanged(day: value.toString()));
                    },
                  ),
                  const SizedBox(height: 15),
                  const ListJadwalUmumCard(),
                ],
              );
      },
    ));
  }
}

class ListJadwalUmumCard extends StatelessWidget {
  const ListJadwalUmumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JadwalUmumBloc, JadwalUmumState>(
        builder: (context, state) {
      return Column(
        children: state.jadwalUmumDisplay
            .map(
              (item) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      item.kelas.nama,
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
                          item.hari,
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: primaryColor),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          item.jamMulai,
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
                          item.instruktur.nama,
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.money, color: primaryColor),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Rp ${ThousandsFormatterString.format(item.kelas.harga)}",
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            )
            .toList(),
      );
    });
  }
}
