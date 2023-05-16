import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingKelas/history_member_booking_kelas_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingKelas/history_member_booking_kelas_state.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../Asset/confirmation_dialog.dart';
import '../Bloc/HistoryMemberBloc/HistoryMemberBookingKelas/history_member_booking_kelas_event.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class HistoryBookingKelasPage extends StatelessWidget {
  const HistoryBookingKelasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryMemberBookingKelasBloc>(
      create: (context) => HistoryMemberBookingKelasBloc(
        bookingKelasRepository: BookingKelasRepository(),
      ),
      child: const HistoryBookingKelasView(),
    );
  }
}

class HistoryBookingKelasView extends StatefulWidget {
  const HistoryBookingKelasView({super.key});

  @override
  State<HistoryBookingKelasView> createState() =>
      _HistoryBookingKelasViewState();
}

class _HistoryBookingKelasViewState extends State<HistoryBookingKelasView> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryMemberBookingKelasBloc>().add(
          HistoryMemberPageFetchedRequested(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryMemberBookingKelasBloc,
        HistoryMemberBookingKelasState>(
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
        if (state.cancelBookingKelasState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil membatalkan booking kelas"),
            ),
          );
          context.read<HistoryMemberBookingKelasBloc>().add(
                HistoryMemberPageFetchedRequested(),
              );
        }
        if (state.cancelBookingKelasState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text((state.cancelBookingKelasState as SubmissionFailed)
                  .exception),
            ),
          );
        }
      }),
      child: BlocBuilder<HistoryMemberBookingKelasBloc,
          HistoryMemberBookingKelasState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.bookingKelasList.isEmpty
                  ? const Center(
                      child: Text('Member belum memiliki aktivitas'),
                    )
                  : const ListBookingKelasCard();
        },
      ),
    );
  }
}

class ListBookingKelasCard extends StatelessWidget {
  const ListBookingKelasCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryMemberBookingKelasBloc,
        HistoryMemberBookingKelasState>(builder: (context, state) {
      return Column(
        children: state.bookingKelasList
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
                    Row(
                      children: [
                        Text(
                          "#${item.id} ${item.jadwalHarian.jadwalUmum.kelas.nama}",
                          style: const TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        item.jadwalHarian.status == 'libur'
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: neutralYellowColor),
                                child: const Text('Diliburkan',
                                    style: TextStyle(color: Colors.white)))
                            : item.isCanceled
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.red),
                                    child: const Text('Dibatalkan',
                                        style: TextStyle(color: Colors.white)))
                                : ElevatedButton(
                                    onPressed: item.isCanceled ||
                                            DateTime.now().compareTo(
                                                    DateTime.parse(item
                                                        .jadwalHarian
                                                        .tanggal)) >
                                                0
                                        ? null
                                        : () {
                                            void cancel() {
                                              BlocProvider.of<
                                                          HistoryMemberBookingKelasBloc>(
                                                      context)
                                                  .add(
                                                      CancelBookingKelasRequested(
                                                          id: item.id));
                                            }

                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ConfirmationDialog(
                                                title: 'Batal',
                                                message:
                                                    'Apakah anda yakin ingin membatalkan booking kelas ${item.jadwalHarian.jadwalUmum.kelas.nama} pada tanggal ${item.jadwalHarian.tanggal} jam ${item.jadwalHarian.jadwalUmum.jamMulai}?',
                                                onYes: () {
                                                  Navigator.pop(context);
                                                  cancel();
                                                },
                                              ),
                                            );
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ),
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
                          "${item.jadwalHarian.jadwalUmum.hari}, ${item.jadwalHarian.tanggal} ${item.jadwalHarian.jadwalUmum.jamMulai}",
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
                          item.jadwalHarian.instrukturPenganti.isEmpty
                              ? item.jadwalHarian.jadwalUmum.instruktur.nama
                              : item.jadwalHarian.instrukturPenganti,
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Dibuat pada ${item.createdAt}",
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
    });
  }
}