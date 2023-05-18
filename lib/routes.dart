import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Model/jadwal_harian.dart';
import 'package:mobile_gofit/Page/booking_kelas_gym_page.dart';
import 'package:mobile_gofit/Page/booking_kelas_list_page.dart';
import 'package:mobile_gofit/Page/change_password_page.dart';
import 'package:mobile_gofit/Page/home_mo.dart';
import 'package:mobile_gofit/Page/home_guest.dart';
import 'package:mobile_gofit/Page/home_instruktur_page.dart';
import 'package:mobile_gofit/Page/izin_instruktur_page.dart';
import 'package:mobile_gofit/Page/izin_instruktur_tambah_page.dart';
import 'package:mobile_gofit/Page/jadwal_umum_page.dart';
import 'package:mobile_gofit/Page/profile_instruktur_page.dart';
import 'package:mobile_gofit/Page/setting_page.dart';
import 'Bloc/AppBloc/app_bloc.dart';
import 'Page/bottom_navigation_bar.dart';
import 'Page/history_member.dart';
import 'Page/home_member_page.dart';
import 'Page/list_member_booking_kelas_page.dart';
import 'Page/login_page.dart';
import 'Page/profile_member_page.dart';
import 'Repository/jadwal_umum_guest_page.dart';

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
          mainPageContent: HomeMOPage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/home-guest',
      builder: (context, state) => const BotttomNavigationBarPage(
          mainPageContent: HomeGuestPage(), selectedIndex: 0),
    ),
    GoRoute(
        path: '/jadwal-umum-guest',
        builder: (context, state) => const BotttomNavigationBarPage(
            mainPageContent: JadwalUmumGuestPage(), selectedIndex: 1)),
    GoRoute(
      path: '/history-member',
      builder: (context, state) => BotttomNavigationBarPage(
          mainPageContent: HistoryMemberPage(gymKelas: (state.extra as int)),
          selectedIndex: 1),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => BotttomNavigationBarPage(
          mainPageContent: const SettingPage(),
          selectedIndex: context.read<AppBloc>().state.user.role == 2 ? 1 : 2),
    ),
    GoRoute(
      path: '/profile-member',
      builder: (context, state) => const ProfileMemberPage(),
    ),
    GoRoute(
      path: '/profile-instruktur',
      builder: (context, state) => const ProfileInstrukturPage(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/booking-gym-kelas',
      builder: (context, state) => BookingKelasGymPage(
        jadwalHarianSelected:
            ((state.extra as Map<String, dynamic>)['jadwalHarianSelected'] ??
                JadwalHarian.empty) as JadwalHarian,
        gymKelas: ((state.extra as Map<String, dynamic>)['gymKelas'] as int),
      ),
    ),
    GoRoute(
      path: '/booking-kelas-list',
      builder: (context, state) => const BookingKelasListPage(),
    ),
    GoRoute(
      path: '/list-member-booking-kelas',
      builder: (context, state) =>
          ListMemberBookingKelasPage(jadwalHarianId: state.extra.toString()),
    ),
    GoRoute(
      path: '/izin-instruktur',
      builder: (context, state) => const IzinInstrukturPage(),
    ),
    GoRoute(
      path: '/izin-instruktur/tambah',
      builder: (context, state) => const IzinInstrukturTambahPage(),
    ),
    GoRoute(
      path: '/jadwal-umum',
      builder: (context, state) => const JadwalUmumPage(),
    ),
  ],
  initialLocation: '/login',
);
