import 'package:coach_workout/utils/utils.dart';
import 'package:coach_workout/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Center(
            child: SizedBox(
              height: 52,
              width: context.deviceSize.width - 30,
              //search fiel
              child: TextField(
                onChanged: null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hint: Text('Fill your context ....'),
                  fillColor: context.colorScheme.surface,
                  focusColor: context.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          TextTile(
            title: 'Breakfast Plan For You',
            subtitle: 'Start your day with a healthy and energizing breakfast.',
          ),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/tip1.jpg',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/food2.png',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/food3.png',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          TextTile(
            title: 'Lunch Plan For You',
            subtitle: 'Keep your energy up with a balanced and filling lunch.',
          ),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/food1.png',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/tip1.jpg',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          FoodCard(
            title: 'Delights with\nGreek yogurt',
            calories: 120,
            mealType: 'Lunch',
            imagePath: 'assets/tip1.jpg',
            time: '8 Mins',
            onTap: () {},
          ),
          const Gap(10),
          TextTile(
            title: 'Dinner Plan For You',
            subtitle: 'End your day with a light and nutritious dinner.',
          ),
          TextTile(
            title: 'Mini Meal Plan For You',
            subtitle: 'Healthy snacks to keep you fueled between main meals.',
          ),
          TextTile(
            title: 'Drink For You',
            subtitle: 'Healthy snacks to keep you fueled between main meals.',
          ),
        ],
      ),
    );
  }
}
