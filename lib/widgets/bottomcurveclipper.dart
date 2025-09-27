

import 'package:flutter/material.dart';

/// Custom clipper tạo khối trắng bo góc trên, cong xuống ở dưới
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 29.0;

    final path = Path();

    // Góc trên trái
    path.moveTo(0, 0);

    // Cạnh trên
    path.lineTo(size.width, 0);

    // Góc trên phải
    path.quadraticBezierTo(size.width, 0, size.width, 0);

    // Xuống cạnh phải
    path.lineTo(size.width, size.height - radius * 2);

    // Vẽ cung cong hướng xuống
    path.quadraticBezierTo(
      size.width / 2,
      size.height + radius, // control point
      0,
      size.height - radius * 2, // end point
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
