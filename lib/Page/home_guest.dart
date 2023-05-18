import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../const.dart';

class HomeGuestPage extends StatelessWidget {
  const HomeGuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Guest!',
                  style: TextStyle(
                    color: accentColor,
                    fontFamily: 'roboto',
                  ),
                ),
                Text(
                  DateFormat('EEEE, dd MMMM', 'id').format(DateTime.now()),
                  style: TextStyle(
                    color: accentColor,
                    fontFamily: 'roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 15,
              child: Text(
                'G',
                style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    color: textColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          'Gym GoFit',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
