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
        return decoded
            .map((item) => GroupExerciseItem.fromJson(item))
            .toList();
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
}
