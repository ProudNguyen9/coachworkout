import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class NutritionPlanScreen extends StatelessWidget {
  const NutritionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // 🔹 Data mẫu
    final List<Map<String, dynamic>> meals = [
      {
        'name': 'Breakfast',
        'calories': 420,
        'food': 'Oatmeal with banana & nuts',
        'image':
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800',
      },
      {
        'name': 'Lunch',
        'calories': 650,
        'food': 'Grilled chicken with brown rice & broccoli',
        'image':
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
      },
      {
        'name': 'Snack',
        'calories': 200,
        'food': 'Protein shake with berries',
        'image':
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800',
      },
      {
        'name': 'Dinner',
        'calories': 580,
        'food': 'Salmon with quinoa & avocado',
        'image':
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
      },
    ];

    const double dailyGoal = 2000;
    final double consumed = meals.fold(
      0,
      (sum, meal) => sum + (meal['calories'] as num).toDouble(),
    );

    final double percent = consumed / dailyGoal;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== HEADER ======
              Text(
                "Today's Nutrition Plan",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Track your meals and stay within your calorie goal.",
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),

              // ====== PROGRESS CARD ======
              _ProgressCard(
                consumed: consumed,
                goal: dailyGoal,
                percent: percent,
              ),
              const SizedBox(height: 30),

              // ====== MEAL LIST ======
              Text(
                "Your Meals",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              ...List.generate(meals.length, (i) {
                final m = meals[i];
                return FadeInUp(
                  duration: Duration(milliseconds: 200 + i * 120),
                  child: _MealCard(
                    width: width,
                    name: m['name'],
                    food: m['food'],
                    calories: m['calories'],
                    imageUrl: m['image'],
                  ),
                );
              }),

              const SizedBox(height: 40),

              // ====== SUGGESTION ======
              Text(
                "Today's Suggestion",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _SuggestionBox(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== WIDGETS ==================

class _ProgressCard extends StatelessWidget {
  final double consumed;
  final double goal;
  final double percent;

  const _ProgressCard({
    required this.consumed,
    required this.goal,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00C853),
                  ),
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${consumed.toInt()} / ${goal.toInt()} kcal",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Calories consumed today",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final double width;
  final String name;
  final String food;
  final int calories;
  final String imageUrl;

  const _MealCard({
    required this.width,
    required this.name,
    required this.food,
    required this.calories,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$calories kcal",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF00C853),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E676), Color(0xFF1DE9B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Tip: Stay hydrated! Drink at least 2L of water today 💧",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
