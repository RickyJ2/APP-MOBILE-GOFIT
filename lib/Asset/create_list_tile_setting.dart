import 'package:flutter/material.dart';

import '../const.dart';

class CreateListTileSetting extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final void Function()? onTap;
  final bool haveTrailing;
  const CreateListTileSetting({
    super.key,
    required this.leading,
    required this.title,
    this.onTap,
    this.subtitle,
    this.haveTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle ?? "") : null,
          onTap: onTap,
          trailing: haveTrailing ? const Icon(Icons.arrow_forward_ios) : null,
        ),
        Divider(
          color: textColorSecond,
          thickness: 0.4,
        ),
      ],
    );
  }
}
