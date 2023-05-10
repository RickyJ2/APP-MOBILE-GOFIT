import 'package:flutter/material.dart';
import 'package:mobile_gofit/Asset/thousands_formater.dart';

import '../Model/jadwal_harian.dart';
import '../const.dart';

class CardJadwalHarian extends StatelessWidget {
  final JadwalHarian jadwalHarian;
  final Widget? action;
  const CardJadwalHarian({
    super.key,
    required this.jadwalHarian,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
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
          Text(
            jadwalHarian.jadwalUmum.kelas.nama,
            style: const TextStyle(
              fontFamily: 'SchibstedGrotesk',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
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
                "${jadwalHarian.jadwalUmum.hari}, ${jadwalHarian.tanggal}",
                style: TextStyle(
                    color: accentColor, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Icon(Icons.schedule, color: primaryColor),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                jadwalHarian.jadwalUmum.jamMulai,
                style: TextStyle(
                    color: accentColor, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Icon(Icons.person, color: primaryColor),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                jadwalHarian.instrukturPenganti.isEmpty
                    ? jadwalHarian.jadwalUmum.instruktur.nama
                    : jadwalHarian.instrukturPenganti,
                style: TextStyle(
                    color: accentColor, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.payments, color: primaryColor),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Rp ${ThousandsFormatterString.format(jadwalHarian.jadwalUmum.kelas.harga)}",
                    style: TextStyle(
                        color: accentColor, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.people, color: primaryColor),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "${jadwalHarian.count} of 10",
                    style: TextStyle(
                        color: accentColor, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          action ?? const SizedBox(),
        ],
      ),
    );
  }
}
