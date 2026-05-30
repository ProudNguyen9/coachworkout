import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final Set<DateTime> workoutDays = {
    DateTime(2025, 10, 1),
    DateTime(2025, 10, 2),
    DateTime(2025, 10, 3),
    DateTime(2025, 10, 5),
    DateTime(2025, 10, 6),
  };

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    /// ✅ QUAN TRỌNG: set locale cho DateFormat
    Intl.defaultLocale = context.locale.languageCode;

    return SizedBox(
      width: context.deviceSize.width,
      height: 340,
      child: TableCalendar(
        locale: context.locale.languageCode, // ✅ QUAN TRỌNG
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,

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
            final hasWorkout = workoutDays.any((d) => _isSameDay(d, day));
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
            return null;
          },
        ),
      ),
    );
  }
}


