import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/Page/booking_kelas_gym_page.dart';
import 'package:mobile_gofit/Page/booking_kelas_list_page.dart';
import 'package:mobile_gofit/Page/booking_kelas_page.dart';
import 'package:mobile_gofit/Page/change_password_page.dart';
import 'package:mobile_gofit/Page/home_instruktur_page.dart';
import 'package:mobile_gofit/Page/izin_instruktur_page.dart';
import 'package:mobile_gofit/Page/izin_instruktur_tambah_page.dart';
import 'package:mobile_gofit/Page/setting_page.dart';
import 'Bloc/AppBloc/app_bloc.dart';
import 'Page/bottom_navigation_bar.dart';
import 'Page/home_member_page.dart';
import 'Page/login_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home-member',
      builder: (context, state) => const BotttomNavigationBarPage(
          mainPageContent: HomeMemberPage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/home-instruktur',
      builder: (context, state) => const BotttomNavigationBarPage(
          mainPageContent: HomeInstrukturPage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/home-MO',
      builder: (context, state) => const BotttomNavigationBarPage(
          mainPageContent: HomeMemberPage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/home-guest',
      builder: (context, state) => const BotttomNavigationBarPage(
          mainPageContent: HomeMemberPage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => BotttomNavigationBarPage(
          mainPageContent: const SettingPage(),
          selectedIndex: context.read<AppBloc>().state.user.role == 2 ? 1 : 2),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/booking-kelas',
      builder: (context, state) => BookingKelasGymPage(
        mainPageContent: BookingKelasPage(
            jadwalHarianSelected:
                (state.extra ?? JadwalHarian.empty) as JadwalHarian),
      ),
    ),
    GoRoute(
      path: '/booking-kelas-list',
      builder: (context, state) => const BookingKelasListPage(),
    ),
    GoRoute(
        path: '/izin-instruktur',
        builder: (context, state) => const IzinInstrukturPage()),
    GoRoute(
      path: '/izin-instruktur/tambah',
      builder: (context, state) => const IzinInstrukturTambahPage(),
    )
  ],
  initialLocation: '/login',
);
