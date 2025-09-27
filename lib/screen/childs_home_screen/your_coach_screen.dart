import 'package:coach_workout/widgets/common_TextTile.dart';
import 'package:flutter/material.dart';

class YoursCoach extends StatelessWidget {
  const YoursCoach({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextTile(title: 'The coach you are learning from'),
          Row(children: [SingleChildScrollView()]),
        ],
      ),
    );
  }
}
