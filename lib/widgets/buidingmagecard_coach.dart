import 'package:flutter/material.dart';

Widget buildCoachCard(String imageUrl, String name) {
  return Container(
    width: 120,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Column(
      children: [
        Stack(
          children: [
            CircleAvatar(radius: 45, backgroundImage: NetworkImage(imageUrl)),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(Icons.check_circle, color: Colors.blue, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: BorderSide(color: Color(0xFF00B5D8)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(60, 30),
          ),
          child: const Text(
            "Coach",
            style: TextStyle(color: Color(0xFF00B5D8)),
          ),
        ),
      ],
    ),
  );
}
