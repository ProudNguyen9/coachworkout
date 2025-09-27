import 'package:flutter/material.dart';

class CardTip extends StatelessWidget {
  final String title;
  final String path;
  final VoidCallback onTap;
  const CardTip({
    super.key,
    required this.title,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              path,
              width: 165,
              height: 134,
              fit: BoxFit.cover,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}
