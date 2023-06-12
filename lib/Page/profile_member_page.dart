import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/const.dart';

import '../Asset/profile_text_form_field.dart';
import '../Asset/thousands_formater.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../Model/member.dart';

class ProfileMemberPage extends StatelessWidget {
  const ProfileMemberPage({super.key});

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
          title: const Text("Profile Member"),
          centerTitle: true,
        ),
        body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
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
                      (state.user.user as Member).nama[0],
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
                    (state.user.user as Member).id,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (state.user.user as Member).deactivedMembershipAt !=
                            'Belum Aktif'
                        ? 'Membership aktif sampai dengan ${(state.user.user as Member).deactivedMembershipAt}'
                        : 'Membership belum aktif',
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
                    initialValue: (state.user.user as Member).nama,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon:
                        Icon(Icons.account_circle_outlined, color: accentColor),
                    labelText: 'Username',
                    initialValue: (state.user.user as Member).nama,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon:
                        Icon(Icons.calendar_month_outlined, color: accentColor),
                    labelText: 'Tanggal Lahir',
                    initialValue: (state.user.user as Member).tglLahir,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.mail_outline, color: accentColor),
                    labelText: 'Email',
                    initialValue: (state.user.user as Member).email,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.phone_outlined, color: accentColor),
                    labelText: 'Nomor Telepon',
                    initialValue: (state.user.user as Member).noTelp,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon:
                        Icon(Icons.pin_drop_outlined, color: accentColor),
                    labelText: 'Alamat',
                    initialValue: (state.user.user as Member).alamat,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.money_outlined, color: accentColor),
                    labelText: 'Deposit Reguler',
                    initialValue:
                        'Rp ${ThousandsFormatterString.format((state.user.user as Member).depositReguler.toString())}',
                  ),
                  const SizedBox(height: 16),
                  ProfileTextFormField(
                    prefixIcon: Icon(Icons.class_outlined, color: accentColor),
                    labelText: 'Deposit Kelas Paket',
                    helperText: (state.user.user as Member)
                                .deactivedDepositKelasPaket !=
                            'Belum Aktif'
                        ? 'Aktif sampai dengan ${(state.user.user as Member).deactivedDepositKelasPaket}'
                        : 'Paket belum aktif',
                    initialValue: (state.user.user as Member)
                                .depositKelasPaket ==
                            0
                        ? '0 Paket'
                        : '${(state.user.user as Member).depositKelasPaket} ${(state.user.user as Member).kelasDepositKelasPaket}',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
