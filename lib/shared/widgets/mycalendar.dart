import 'package:coach_workout/core/services/supabase_service.dart';
import 'package:coach_workout/core/services/workout_streak_service.dart';
import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Set<String> workoutDayKeys = {};
  Set<String> plannedDayKeys = {};
  Set<String> restDayKeys = {};

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void initState() {
    super.initState();
    _syncCalendarStatus();
  }

  Future<void> _syncCalendarStatus() async {
    final localWorkoutKeys = WorkoutStreakService.getWorkoutDayKeys();
    setState(() => workoutDayKeys = localWorkoutKeys);

    try {
      final status = await SupabaseService().getMyCalendarTrainingStatus();
      if (!mounted) return;
      setState(() {
        plannedDayKeys = status['planned'] ?? <String>{};
        restDayKeys = status['rest'] ?? <String>{};
        workoutDayKeys = {
          ...localWorkoutKeys,
          ...(status['completed'] ?? <String>{}),
        };
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => workoutDayKeys = localWorkoutKeys);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceSize.width,
      height: 300,
      child: TableCalendar(
        locale: context.locale.languageCode, // ✅ QUAN TRỌNG
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        daysOfWeekHeight: 28,
        rowHeight: 36,

        selectedDayPredicate: (day) =>
            _selectedDay != null && _isSameDay(day, _selectedDay!),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        calendarFormat: CalendarFormat.month,

        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(vertical: 6),
          leftChevronPadding: EdgeInsets.zero,
          rightChevronPadding: EdgeInsets.zero,
          titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),

        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: Colors.cyan,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          outsideTextStyle: TextStyle(color: Colors.grey.shade400),
          markersAlignment: Alignment.bottomCenter,
          markersMaxCount: 1,
        ),

        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final dayKey =
                '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
            final hasWorkout = workoutDayKeys.contains(dayKey);
            final hasPlan = plannedDayKeys.contains(dayKey);
            final isRestDay = restDayKeys.contains(dayKey);

            if (hasWorkout) {
              return const Positioned(
                bottom: 4,
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.orangeAccent,
                  size: 18,
                ),
              );
            }

            if (isRestDay) {
              return const Positioned(
                bottom: 4,
                child: Icon(
                  Icons.self_improvement,
                  color: Colors.green,
                  size: 16,
                ),
              );
            }

            if (hasPlan) {
              return const Positioned(
                bottom: 4,
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.blueAccent,
                  size: 16,
                ),
              );
            }

            return null;
          },
        ),
      ),
    );
  }
}
