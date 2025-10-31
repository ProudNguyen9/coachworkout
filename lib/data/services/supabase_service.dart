import 'dart:convert';

import 'package:coach_workout/data/models/group_exercise.dart';
import 'package:coach_workout/data/models/groupexerciseitem.dart';
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
}
