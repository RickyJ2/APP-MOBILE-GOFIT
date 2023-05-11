import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Asset/create_drop_down_button.dart';
import 'package:mobile_gofit/Asset/create_text_form_field.dart';
import 'package:mobile_gofit/Bloc/AppBloc/app_bloc.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/IzinInstrukturTambahBloc/izin_instruktur_tambah_bloc.dart';
import 'package:mobile_gofit/Bloc/IzinInstrukturBloc/IzinInstrukturTambahBloc/izin_instruktur_tambah_state.dart';
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Repository/instruktur_repository.dart';
import 'package:mobile_gofit/Repository/izin_instruktur_repository.dart';
import 'package:mobile_gofit/Repository/jadwal_umum_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:mobile_gofit/StateBlocTemplate/page_fetched_data_state.dart';
import 'package:mobile_gofit/const.dart';

import '../Bloc/IzinInstrukturBloc/IzinInstrukturTambahBloc/izin_instruktur_tambah_event.dart';
import '../Model/jadwal_umum.dart';

class IzinInstrukturTambahPage extends StatelessWidget {
  const IzinInstrukturTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IzinInstrukturTambahBloc>(
        create: (context) => IzinInstrukturTambahBloc(
              instrukturRepository: InstrukturRepository(),
              izinInstrukturRepository: IzinInstrukturRepository(),
              jadwalUmumRepository: JadwalUmumRepository(),
            ),
        child: const IzinInstrukturTambahView());
  }
}

class IzinInstrukturTambahView extends StatefulWidget {
  const IzinInstrukturTambahView({super.key});

  @override
  State<IzinInstrukturTambahView> createState() =>
      _IzinInstrukturTambahViewState();
}

class _IzinInstrukturTambahViewState extends State<IzinInstrukturTambahView> {
  final TextEditingController _tglIzinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<IzinInstrukturTambahBloc>()
        .add(IzinInstrukturPageFetchedRequested());
    _tglIzinController.addListener(() {
      _onTglIzinChanged();
    });
  }

  @override
  void dispose() {
    _tglIzinController.dispose();
    super.dispose();
  }

  void _onTglIzinChanged() {
    final newValue = _tglIzinController.text;
    context
        .read<IzinInstrukturTambahBloc>()
        .add(IzinInstrukturTanggalIzinFormChanged(
          tanggalIzinForm: newValue,
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initTime = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initTime,
      firstDate: DateTime(DateTime.now().month),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _tglIzinController.text =
          '${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IzinInstrukturTambahBloc, IzinInstrukturTambahState>(
        listener: (context, state) {
      if (state.formSubmissionState is SubmissionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Izin berhasil ditambahkan"),
          ),
        );
        Navigator.pop(context);
      }
      if (state.formSubmissionState is SubmissionFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text((state.formSubmissionState as SubmissionFailed).exception),
          ),
        );
      }
      if (state.pageFetchedDataState is PageFetchedDataFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((state.pageFetchedDataState as PageFetchedDataFailed)
                .exception),
          ),
        );
      }
      if (state.jadwalUmumListFetchedDataState is PageFetchedDataFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                (state.jadwalUmumListFetchedDataState as PageFetchedDataFailed)
                    .exception),
          ),
        );
      }
    }, child: BlocBuilder<IzinInstrukturTambahBloc, IzinInstrukturTambahState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: textColor,
              title: const Text("Tambah izin Instruktur"),
            ),
            body: state.pageFetchedDataState is PageFetchedDataLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          CreateTextFormField(
                            labelText: "Instruktur Pengaju",
                            initialValue: (BlocProvider.of<AppBloc>(context)
                                    .state
                                    .user
                                    .user as Instruktur)
                                .nama,
                            enabled: false,
                          ),
                          const SizedBox(height: 16),
                          CreateTextFormField(
                            controller: _tglIzinController,
                            labelText: "Tanggal Izin",
                            hintText: "Pilih tanggal izin",
                            validator: (value) =>
                                state.izinInstrukturError.tanggalIzin == ''
                                    ? null
                                    : state.izinInstrukturError.tanggalIzin,
                            onTap: () => _selectDate(context),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CreateDropDownButton(
                            label: "Kelas",
                            errorText:
                                state.izinInstrukturError.jadwalUmum.id == ''
                                    ? null
                                    : state.izinInstrukturError.jadwalUmum.id,
                            value: state.izinInstrukturForm.jadwalUmum,
                            items: state.jadwalUmumList
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                          "${e.kelas.nama} - ${e.jamMulai}"),
                                    ))
                                .toList(),
                            onChanged: state.isSelectJadwalUmumEnabled
                                ? (value) {
                                    context
                                        .read<IzinInstrukturTambahBloc>()
                                        .add(
                                          IzinInstrukturFormChanged(
                                            izinInstrukturForm: state
                                                .izinInstrukturForm
                                                .copyWith(
                                              jadwalUmum: value as JadwalUmum,
                                            ),
                                          ),
                                        );
                                  }
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CreateDropDownButton(
                            label: "Instruktur Penganti",
                            errorText: state.izinInstrukturError
                                        .instrukturPenganti.id ==
                                    ''
                                ? null
                                : state
                                    .izinInstrukturError.instrukturPenganti.id,
                            value: state.izinInstrukturForm.instrukturPenganti,
                            items: state.instrukturList
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.nama),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              context.read<IzinInstrukturTambahBloc>().add(
                                    IzinInstrukturFormChanged(
                                      izinInstrukturForm:
                                          state.izinInstrukturForm.copyWith(
                                              instrukturPenganti:
                                                  value as Instruktur),
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 16),
                          CreateTextFormField(
                            labelText: "Keterangan",
                            hintText: "Masukkan keterangan",
                            validator: (value) =>
                                state.izinInstrukturError.keterangan == ''
                                    ? null
                                    : state.izinInstrukturError.keterangan,
                            onChanged: (value) {
                              context.read<IzinInstrukturTambahBloc>().add(
                                    IzinInstrukturFormChanged(
                                      izinInstrukturForm: state
                                          .izinInstrukturForm
                                          .copyWith(keterangan: value),
                                    ),
                                  );
                            },
                            maxLines: 3,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<IzinInstrukturTambahBloc>()
                                    .add(IzinInstrukturFormSubmitted());
                              },
                              child: Stack(
                                children: [
                                  state.formSubmissionState is FormSubmitting
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
                                      state.formSubmissionState
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
                  ),
          ),
        );
      },
    ));
  }
}
