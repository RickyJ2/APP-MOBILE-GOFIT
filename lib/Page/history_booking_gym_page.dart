import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingGym/history_member_booking_gym_bloc.dart';
import 'package:mobile_gofit/Bloc/HistoryMemberBloc/HistoryMemberBookingGym/history_member_booking_gym_state.dart';
import 'package:mobile_gofit/Repository/booking_gym_repository.dart';

import '../Asset/confirmation_dialog.dart';
import '../Bloc/HistoryMemberBloc/HistoryMemberBookingGym/history_member_booking_gym_event.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class HistoryBookingGymPage extends StatelessWidget {
  const HistoryBookingGymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryMemberBookingGymBloc>(
      create: (context) => HistoryMemberBookingGymBloc(
        bookingGymRepository: BookingGymRepository(),
      ),
      child: const HistoryBookingGymView(),
    );
  }
}

class HistoryBookingGymView extends StatefulWidget {
  const HistoryBookingGymView({super.key});

  @override
  State<HistoryBookingGymView> createState() => _HistoryBookingGymViewState();
}

class _HistoryBookingGymViewState extends State<HistoryBookingGymView> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<HistoryMemberBookingGymBloc>()
        .add(HistoryMemberBookinGymFetchedRequested());
    _startDateController.addListener(() {
      _onDateChanged();
    });
    _endDateController.addListener(() {
      _onDateChanged();
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _onDateChanged() {
    context.read<HistoryMemberBookingGymBloc>().add(
          HistoryMemberBookingGymDateChanged(
            startDate: _startDateController.text,
            endDate: _endDateController.text,
          ),
        );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initTime = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: initTime,
        end: initTime,
      ),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      DateTime startDate = picked.start;
      DateTime endDate = picked.end;
      _startDateController.text =
          '${startDate.year.toString()}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      _endDateController.text =
          '${endDate.year.toString()}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryMemberBookingGymBloc,
        HistoryMemberBookingGymState>(
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
        if (state.cancelBookingGymState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil membatalkan booking gym"),
            ),
          );
          context.read<HistoryMemberBookingGymBloc>().add(
                HistoryMemberBookinGymFetchedRequested(),
              );
        }
        if (state.cancelBookingGymState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.cancelBookingGymState as SubmissionFailed).exception),
            ),
          );
        }
      }),
      child: BlocBuilder<HistoryMemberBookingGymBloc,
          HistoryMemberBookingGymState>(builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Pilih tanggal',
                  onPressed: state.bookingGymList.isEmpty &&
                          state.startDate == '' &&
                          state.endDate == ''
                      ? null
                      : () {
                          _selectDate(context);
                        },
                  icon: const Icon(Icons.calendar_today),
                  color: primaryColor,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Start Date',
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                const Text('to'),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'End Date',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            state.pageFetchedDataState is PageFetchedDataLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.bookingGymList.isEmpty
                    ? const Center(
                        child: Text('Member belum memiliki booking gym'),
                      )
                    : const ListBookingGymCard(),
          ],
        );
      }),
    );
  }
}

class ListBookingGymCard extends StatelessWidget {
  const ListBookingGymCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryMemberBookingGymBloc,
        HistoryMemberBookingGymState>(builder: (context, state) {
      return Column(
        children: state.bookingGymList
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
                          "#${item.id} Sesi ${item.sesiGym.id}",
                          style: const TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        item.isCanceled
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
                                                DateTime.parse(item.tanggal)) >
                                            0
                                    ? null
                                    : () {
                                        void cancel() {
                                          BlocProvider.of<
                                                      HistoryMemberBookingGymBloc>(
                                                  context)
                                              .add(CancelBookingGymRequested(
                                                  id: item.id));
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ConfirmationDialog(
                                            title: 'Batal',
                                            message:
                                                'Apakah anda yakin ingin membatalkan booking gym sesi ${item.sesiGym.id} pada tanggal ${item.tanggal}?',
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
                          item.tanggal,
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
                          "${item.sesiGym.jamMulai} - ${item.sesiGym.jamSelesai}",
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
                    item.isCanceled ||
                            DateTime.now()
                                    .compareTo(DateTime.parse(item.tanggal)) >
                                0
                        ? Text(
                            item.presentAt == ''
                                ? 'Tidak hadir'
                                : "Presensi pada ${item.presentAt}",
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.normal),
                          )
                        : const SizedBox(),
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
