import 'package:flutter/material.dart';

import '../Page/jadwal_umum_page.dart';
import '../const.dart';

class JadwalUmumGuestPage extends StatelessWidget {
  const JadwalUmumGuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jadwal Umum',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        const JadwalUmumPageView(),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
