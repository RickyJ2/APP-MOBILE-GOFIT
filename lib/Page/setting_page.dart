import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Model/instruktur.dart';
import 'package:mobile_gofit/Model/member.dart';
import 'package:mobile_gofit/Model/pegawai.dart';

import '../Asset/create_list_tile_setting.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../const.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'SchibstedGrotesk',
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            state.user.role == 0
                ? CreateListTileSetting(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 20,
                      child: Text(
                        (state.user.user as Member).username[0],
                        style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: (state.user.user as Member).username,
                    subtitle: (state.user.user as Member).email,
                    onTap: () {
                      //context.push('/profile');
                    },
                  )
                : const SizedBox(),
            state.user.role == 1
                ? CreateListTileSetting(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 20,
                      child: Text(
                        (state.user.user as Instruktur).username[0],
                        style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: (state.user.user as Instruktur).username,
                    subtitle: (state.user.user as Instruktur).nama,
                    onTap: () {
                      //context.push('/profile');
                    },
                  )
                : const SizedBox(),
            state.user.role == 2
                ? CreateListTileSetting(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 20,
                      child: Text(
                        (state.user.user as Pegawai).username[0],
                        style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: (state.user.user as Pegawai).username,
                    subtitle: "Manajer Operasional",
                    onTap: () {
                      //context.push('/profile');
                    },
                  )
                : const SizedBox(),
            state.user.role == 3
                ? CreateListTileSetting(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 20,
                      child: Text(
                        'G',
                        style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: "Guest",
                    haveTrailing: false,
                  )
                : const SizedBox(),
            state.user.role == 1 || state.user.role == 2
                ? CreateListTileSetting(
                    leading: const Icon(Icons.lock),
                    title: "Ubah Password",
                    onTap: () {
                      context.push('/change-password');
                    },
                  )
                : const SizedBox(),
            state.user.role == 1
                ? CreateListTileSetting(
                    leading: const Icon(Icons.article),
                    title: "Izin Kelas",
                    onTap: () {
                      context.push('/change-password');
                    },
                  )
                : const SizedBox(),
            CreateListTileSetting(
              leading: const Icon(Icons.calendar_month),
              title: "Jadwal Umum",
              onTap: () {
                //context.push('/change-password');
              },
            ),
            CreateListTileSetting(
              leading: const Icon(Icons.info),
              title: "Info",
              onTap: () {
                //context.push('/change-password');
              },
            ),
            const SizedBox(height: 50),
            state.user.role != 3
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                        context.go('/login');
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: errorTextColor),
                      ),
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Login",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
