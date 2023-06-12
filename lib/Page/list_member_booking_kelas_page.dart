import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Asset/create_drop_down_button.dart';
import 'package:mobile_gofit/Bloc/ListMemberBookingKelasBloc/list_member_booking_kelas_bloc.dart';
import 'package:mobile_gofit/Bloc/ListMemberBookingKelasBloc/list_member_booking_kelas_state.dart';
import 'package:mobile_gofit/Repository/booking_kelas_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../Bloc/ListMemberBookingKelasBloc/list_member_booking_kelas_event.dart';
import '../const.dart';

class ListMemberBookingKelasPage extends StatelessWidget {
  final String jadwalHarianId;
  const ListMemberBookingKelasPage({super.key, required this.jadwalHarianId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListMemberBookingKelasBloc>(
      create: (context) => ListMemberBookingKelasBloc(
          bookingKelasRepository: BookingKelasRepository()),
      child: ListMemberBookingKelasView(
        jadwalHarianId: jadwalHarianId,
      ),
    );
  }
}

class ListMemberBookingKelasView extends StatefulWidget {
  final String jadwalHarianId;
  const ListMemberBookingKelasView({super.key, required this.jadwalHarianId});

  @override
  State<ListMemberBookingKelasView> createState() =>
      _ListMemberBookingKelasViewState();
}

class _ListMemberBookingKelasViewState
    extends State<ListMemberBookingKelasView> {
  @override
  void initState() {
    super.initState();
    context.read<ListMemberBookingKelasBloc>().add(
        ListMemberBookingKelasPageFetchedRequested(id: widget.jadwalHarianId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListMemberBookingKelasBloc,
        ListMemberBookingKelasState>(
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
        if (state.presentFormSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
              ("Presensi Member Berhasil"),
            )),
          );
          Navigator.pop(context);
        }
        if (state.presentFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.presentFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
      },
      child: SafeArea(
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
            title: const Text("Presensi Member"),
            centerTitle: true,
          ),
          body: BlocBuilder<ListMemberBookingKelasBloc,
              ListMemberBookingKelasState>(
            builder: (context, state) {
              return state.pageFetchedDataState is PageFetchedDataLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => primaryColor),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: textColor,
                                      ),
                                    ),
                                    dataRowMinHeight: 80,
                                    dataRowMaxHeight: 100,
                                    columns: const [
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Nama',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Action',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      for (var index = 0;
                                          index < state.bookingKelasList.length;
                                          index++)
                                        DataRow(cells: [
                                          DataCell(
                                            Text(state.bookingKelasList[index]
                                                .member.id),
                                          ),
                                          DataCell(
                                            Text(state.bookingKelasList[index]
                                                .member.nama),
                                          ),
                                          DataCell(
                                            CreateDropDownButton(
                                              value:
                                                  state.bookingKelasList[index]
                                                              .presentAt ==
                                                          ''
                                                      ? presensi[1]
                                                      : presensi[0],
                                              items: presensi
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {
                                                context
                                                    .read<
                                                        ListMemberBookingKelasBloc>()
                                                    .add(
                                                        PresentBookingKelasChanged(
                                                            present: value
                                                                .toString(),
                                                            index: index));
                                              },
                                            ),
                                          ),
                                        ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ListMemberBookingKelasBloc>()
                                      .add(PresentBookingKelasRequested(
                                          id: widget.jadwalHarianId));
                                },
                                child: Stack(
                                  children: [
                                    state.presentFormSubmissionState
                                            is FormSubmitting
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        state.presentFormSubmissionState
                                                is! FormSubmitting
                                            ? 'Simpan'
                                            : '',
                                        style: TextStyle(
                                          fontFamily: 'SchibstedGrotesk',
                                          fontSize: 15,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
