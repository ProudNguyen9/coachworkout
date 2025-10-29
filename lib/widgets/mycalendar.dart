import 'package:coach_workout/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 🔥 Danh sách ngày có biểu tượng lửa (ví dụ: đã tập luyện)
  final Set<DateTime> workoutDays = {
    // Tuần 1
    DateTime.utc(2025, 10, 1),
    DateTime.utc(2025, 10, 2),
    DateTime.utc(2025, 10, 3),
    DateTime.utc(2025, 10, 5),
    DateTime.utc(2025, 10, 6),

    // Tuần 2
    DateTime.utc(2025, 10, 8),
    DateTime.utc(2025, 10, 9),
    DateTime.utc(2025, 10, 10),
    DateTime.utc(2025, 10, 12),

    // Tuần 3
    DateTime.utc(2025, 10, 14),
    DateTime.utc(2025, 10, 15),
    DateTime.utc(2025, 10, 17),
    DateTime.utc(2025, 10, 18),

    // Tuần 4
    DateTime.utc(2025, 10, 20),
    DateTime.utc(2025, 10, 21),
    DateTime.utc(2025, 10, 22),
    DateTime.utc(2025, 10, 23),
    DateTime.utc(2025, 10, 24),

    // Tuần 5
    DateTime.utc(2025, 10, 26),
    DateTime.utc(2025, 10, 27),
    DateTime.utc(2025, 10, 29),
    DateTime.utc(2025, 10, 30),
  };

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceSize.width,
      height: 340,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
            color: Colors.cyan, // ngày hôm nay
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.blue, // ngày được chọn
            shape: BoxShape.circle,
          ),
          outsideTextStyle: TextStyle(color: Colors.grey.shade400),
          // 👇 custom builder để vẽ biểu tượng lửa
          markersAlignment: Alignment.bottomCenter,
          markersMaxCount: 1,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.black87),
          weekdayStyle: TextStyle(color: Colors.black87),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            // Kiểm tra xem ngày này có trong danh sách workout không
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
