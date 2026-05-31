import 'package:hive_flutter/hive_flutter.dart';

class WorkoutStreakService {
  static const String boxName = 'workout_streak_box';
  static const String workoutDaysKey = 'workout_days';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<List>(boxName);
  }

  static Box<List> get _box => Hive.box<List>(boxName);

  static String _dateKey(DateTime date) {
    final local = date.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static Future<void> markWorkoutDone([DateTime? date]) async {
    final days = getWorkoutDayKeys();
    days.add(_dateKey(date ?? DateTime.now()));
    await _box.put(workoutDaysKey, days.toList());
  }

  static Set<String> getWorkoutDayKeys() {
    final rawDays =
        _box.get(workoutDaysKey, defaultValue: <String>[]) ?? <String>[];
    return rawDays.map((day) => day.toString()).toSet();
  }

  static bool hasWorkout(DateTime date) {
    return getWorkoutDayKeys().contains(_dateKey(date));
  }
}
