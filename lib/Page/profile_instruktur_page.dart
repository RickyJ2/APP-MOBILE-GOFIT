import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/AppBloc/app_bloc.dart';
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/const.dart';

import '../Asset/profile_text_form_field.dart';
import '../Bloc/AppBloc/app_state.dart';

class ProfileInstrukturPage extends StatelessWidget {
  const ProfileInstrukturPage({super.key});

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
        title: const Text("Profile Instruktur"),
        centerTitle: true,
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 40,
                    child: Text(
                      (state.user.user as Instruktur).username[0],
                      style: TextStyle(
                          fontFamily: 'SchibstedGrotesk',
                          color: textColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    (state.user.user as Instruktur).username,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Akumulasi terlambat bulan ini ${(state.user.user as Instruktur).akumulasiTerlambat} menit',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: textColorSecond,
                      thickness: 0.4,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.person_outline, color: accentColor),
                    labelText: 'Nama Lengkap',
                    initialValue: (state.user.user as Instruktur).nama,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon:
                        Icon(Icons.calendar_month_outlined, color: accentColor),
                    labelText: 'Nama Lengkap',
                    initialValue: (state.user.user as Instruktur).tglLahir,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.phone_outlined, color: accentColor),
                    labelText: 'Nomor Telepon',
                    initialValue: (state.user.user as Instruktur).noTelp,
                    enabled: false,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
