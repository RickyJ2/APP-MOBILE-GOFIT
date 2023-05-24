import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/AppBloc/app_bloc.dart';

import '../Asset/thousands_formater.dart';
import '../const.dart';

class InfoUmumPage extends StatelessWidget {
  const InfoUmumPage({super.key});

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
        title: const Text("Info Umum"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: InfoUmumView(),
      )),
    ));
  }
}

class InfoUmumView extends StatelessWidget {
  const InfoUmumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GoFit',
          style: TextStyle(
            fontFamily: 'SchibstedGrotesk',
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          BlocProvider.of<AppBloc>(context).state.informasiUmum.alamat,
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: 100.0,
          child: Divider(
            color: primaryColor,
            thickness: 3.0,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          BlocProvider.of<AppBloc>(context).state.informasiUmum.deskripsi,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Biaya Aktivasi Membership : Rp ${ThousandsFormatterString.format(BlocProvider.of<AppBloc>(context).state.informasiUmum.biayaAktivasiMembership.toString())}/tahun',
        ),
        const SizedBox(height: 16.0),
        Image.asset('assets/images/interior_gym.jpg', height: 200),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
