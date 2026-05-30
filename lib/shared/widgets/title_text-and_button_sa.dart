import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class TitleTextAndButtonSA extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const TitleTextAndButtonSA({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextTile(title: title),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'see_all'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}


