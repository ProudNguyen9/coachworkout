import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  final String title;
  final String? subtitle; // có thể null

  const TextTile({
    super.key,
    required this.title,
    this.subtitle, // optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4), // khoảng cách nhỏ
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
