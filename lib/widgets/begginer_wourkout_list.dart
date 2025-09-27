import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final List<Map<String, String>> beginnerWorkouts = [
  {
    "title": "Beginner Push Ups",
    "description": "3 sets × 12 reps",
    "times": "5 mins",
    "path": "https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg",
  },
  {
    "title": "Beginner Squats",
    "description": "3 sets × 15 reps",
    "times": "7 mins",
    "path":
        "https://images.pexels.com/photos/2261485/pexels-photo-2261485.jpeg",
  },
  {
    "title": "Beginner Plank",
    "description": "3 sets × 40 sec",
    "times": "4 mins",
    "path": "https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg",
  },
  {
    "title": "Beginner Lunges",
    "description": "3 sets × 10 reps (each leg)",
    "times": "6 mins",
    "path":
        "https://images.pexels.com/photos/1552106/pexels-photo-1552106.jpeg",
  },
  {
    "title": "Beginner Bicep Curls",
    "description": "3 sets × 12 reps",
    "times": "5 mins",
    "path": "https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg",
  },
];

class ItemListBeginner extends StatelessWidget {
  final String path;
  final String title;
  final String description;
  final String times;
  final VoidCallback ontap;
  const ItemListBeginner({
    super.key,
    required this.path,
    required this.title,
    required this.description,
    required this.ontap,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: GestureDetector(
        onTap: ontap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.red.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(path, fit: BoxFit.cover),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                      Text(
                        times,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 0.1,
                        color: Colors.grey,
                        indent: 0,
                        endIndent: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
