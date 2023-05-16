import 'package:flutter/material.dart';

import '../const.dart';

class ProfileTextFormField extends StatelessWidget {
  final String? labelText;
  final String? helperText;
  final String? initialValue;
  final Widget? prefixIcon;
  final bool? enabled;
  final int? maxLines;

  const ProfileTextFormField({
    super.key,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.enabled,
    this.maxLines,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelStyle: TextStyle(color: accentColor),
        helperStyle: TextStyle(color: accentColor),
      ),
      initialValue: initialValue,
      maxLines: maxLines ?? 1,
      enabled: false,
      readOnly: true,
    );
  }
}
