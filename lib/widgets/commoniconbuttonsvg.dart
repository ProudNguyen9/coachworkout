import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconButtonSvg extends StatelessWidget {
  final VoidCallback onPressed;
  final String path;
  final Color? color;
  const IconButtonSvg({
    super.key,
    required this.onPressed,
    required this.path,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        path,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        color: color,
      ),
    );
  }
}
