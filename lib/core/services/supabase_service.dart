import 'dart:convert';

import 'package:coach_workout/features/workout/data/models/group_exercise.dart';
import 'package:coach_workout/features/workout/data/models/groupexerciseitem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 🔹 Lấy danh sách nhóm bài tập (ví dụ: beginner)
  Future<List<GroupExercise>> getGroupExercisesByLevel({
    required String level,
    int? limitCount,
  }) async {
    try {
      final query = _client
          .from('groupexercise')
          .select('*')
          .eq('level', level)
          .order('created_at', ascending: false);

      if (limitCount != null) query.limit(limitCount);

      final data = await query;

      // ép kiểu sang List<GroupExercise>
      final exercises = (data as List)
          .map((e) => GroupExercise.fromJson(e as Map<String, dynamic>))
          .toList();

      return exercises;
    } catch (e, st) {
      print('❌ Error fetching group exercises: $e');
      print(st);
      return [];
    }
  }

  /// Gọi hàm SQL `get_group_exercise_items(uuid)` trả về JSON chuỗi
  Future<List<GroupExerciseItem>> getGroupExerciseItems(String groupId) async {
    try {
      final response = await _client.rpc(
        'get_group_exercise_items',
        params: {'group_id': groupId},
      );

      if (response == null) return [];

      // Nếu hàm trả về JSON text → decode thủ công
      if (response is String) {
        final List<dynamic> decoded = jsonDecode(response);
        return decoded.map((item) => GroupExerciseItem.fromJson(item)).toList();
      }

      // Nếu Supabase tự parse thành List<dynamic>
      if (response is List) {
        return response
            .map((item) => GroupExerciseItem.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      print('❌ Lỗi khi lấy group exercise items: $e');
      return [];
    }
  }

  Future<void> createUserTrainingFromGroup({
    required String groupExerciseId,
    required String title,
    required List<DateTime> selectedDays,
  }) async {
    if (selectedDays.isEmpty) throw Exception('No days selected');
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('❌ No logged-in user found');
    }

    final userId = user.id;
    final durationDays = selectedDays.length;
    final startDate = selectedDays.first;

    // 1️⃣ Tạo course
    final courseRes = await _client
        .from('training_courses')
        .insert({
          'title': title,
          'description': 'Personal plan based on selected group exercise',
          'level': 'Beginner',
          'duration_days': durationDays,
          'goal': 'Custom plan',
          'type': 'custom by user',
        })
        .select('id')
        .single();

    final courseId = courseRes['id'] as String;

    // 2️⃣ Tạo course_days
    final courseDays = selectedDays.asMap().entries.map((e) {
      final index = e.key;
      return {
        'course_id': courseId,
        'day_number': index + 1,
        'groupexercise_id': groupExerciseId,
      };
    }).toList();

    await _client.from('course_days').insert(courseDays);

    // 3️⃣ Tạo user_schedules
    final scheduleRes = await _client
        .from('user_schedules')
        .insert({
          'user_id': userId,
          'course_id': courseId,
          'start_date': startDate.toIso8601String(),
          'is_active': true,
        })
        .select('id')
        .single();

    final scheduleId = scheduleRes['id'] as String;

    // 4️⃣ Tạo user_schedule_days
    final scheduleDays = selectedDays.asMap().entries.map((e) {
      return {
        'schedule_id': scheduleId,
        'planned_date': e.value.toIso8601String(),
        'course_day_number': e.key + 1,
        'completed': false,
      };
    }).toList();

    await _client.from('user_schedule_days').insert(scheduleDays);

    print('✅ Created user training schedule successfully!');
  }

  Future<List<Map<String, dynamic>>> getMyTrainingSchedules() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('❌ No logged-in user found');
    }

    final schedulesRaw = await _client
        .from('user_schedules')
        .select('id, course_id, start_date, is_active, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    final schedules = (schedulesRaw as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    if (schedules.isEmpty) return [];

    final courseIds = schedules
        .map((schedule) => schedule['course_id'])
        .where((id) => id != null)
        .toSet()
        .toList();
    final scheduleIds = schedules
        .map((schedule) => schedule['id'])
        .where((id) => id != null)
        .toSet()
        .toList();

    final coursesRaw = courseIds.isEmpty
        ? <dynamic>[]
        : await _client
              .from('training_courses')
              .select(
                'id, title, description, level, duration_days, goal, type',
              )
              .inFilter('id', courseIds);

    final daysRaw = scheduleIds.isEmpty
        ? <dynamic>[]
        : await _client
              .from('user_schedule_days')
              .select(
                'id, schedule_id, planned_date, course_day_number, completed',
              )
              .inFilter('schedule_id', scheduleIds)
              .order('planned_date', ascending: true);

    final coursesById = <dynamic, Map<String, dynamic>>{
      for (final course in coursesRaw)
        course['id']: Map<String, dynamic>.from(course),
    };

    final daysByScheduleId = <dynamic, List<Map<String, dynamic>>>{};
    for (final day in daysRaw) {
      final mappedDay = Map<String, dynamic>.from(day);
      final scheduleId = mappedDay['schedule_id'];
      daysByScheduleId.putIfAbsent(scheduleId, () => []).add(mappedDay);
    }

    return schedules.map((schedule) {
      final scheduleId = schedule['id'];
      return {
        ...schedule,
        'course': coursesById[schedule['course_id']],
        'days': daysByScheduleId[scheduleId] ?? <Map<String, dynamic>>[],
      };
    }).toList();
  }

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> markTodayScheduleDayCompleted() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final todayKey = _dateKey(DateTime.now());

    final schedulesRaw = await _client
        .from('user_schedules')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_active', true);

    final scheduleIds = (schedulesRaw as List)
        .map((schedule) => (schedule as Map)['id'])
        .where((id) => id != null)
        .toList();

    if (scheduleIds.isEmpty) return;

    final daysRaw = await _client
        .from('user_schedule_days')
        .select('id, planned_date')
        .inFilter('schedule_id', scheduleIds);

    final todayDayIds = (daysRaw as List)
        .map((day) => Map<String, dynamic>.from(day as Map))
        .where((day) {
          final plannedDate = DateTime.tryParse('${day['planned_date']}');
          return plannedDate != null && _dateKey(plannedDate) == todayKey;
        })
        .map((day) => day['id'])
        .where((id) => id != null)
        .toList();

    if (todayDayIds.isEmpty) return;

    await _client
        .from('user_schedule_days')
        .update({'completed': true})
        .inFilter('id', todayDayIds);
  }

  Future<Map<String, Set<String>>> getMyCalendarTrainingStatus() async {
    final schedules = await getMyTrainingSchedules();
    final plannedKeys = <String>{};
    final completedKeys = <String>{};
    final restKeys = <String>{};

    for (final schedule in schedules) {
      final days = (schedule['days'] as List? ?? [])
          .map((day) => Map<String, dynamic>.from(day as Map))
          .toList();

      DateTime? firstDate;
      DateTime? lastDate;

      for (final day in days) {
        final plannedDate = DateTime.tryParse('${day['planned_date']}');
        if (plannedDate == null) continue;

        final dayKey = _dateKey(plannedDate);
        plannedKeys.add(dayKey);

        if (day['completed'] == true) {
          completedKeys.add(dayKey);
        }

        if (firstDate == null || plannedDate.isBefore(firstDate)) {
          firstDate = plannedDate;
        }
        if (lastDate == null || plannedDate.isAfter(lastDate)) {
          lastDate = plannedDate;
        }
      }

      if (firstDate == null || lastDate == null) continue;

      var cursor = DateTime(firstDate.year, firstDate.month, firstDate.day);
      final end = DateTime(lastDate.year, lastDate.month, lastDate.day);
      while (!cursor.isAfter(end)) {
        final dayKey = _dateKey(cursor);
        if (!plannedKeys.contains(dayKey)) {
          restKeys.add(dayKey);
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }

    return {
      'planned': plannedKeys,
      'completed': completedKeys,
      'rest': restKeys,
    };
  }
}
