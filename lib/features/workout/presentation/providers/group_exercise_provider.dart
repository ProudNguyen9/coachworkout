import 'package:coach_workout/features/workout/data/models/group_exercise.dart';
import 'package:coach_workout/features/workout/data/models/groupexerciseitem.dart';
import 'package:coach_workout/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';

class GroupExerciseProvider with ChangeNotifier {
  final _service = SupabaseService();

  List<GroupExercise> _beginnerList = [];

  // ✅ Cache nhiều group, mỗi groupId có list riêng
  final Map<String, List<GroupExerciseItem>> _groupItemsCache = {};

  bool _isLoading = false;
  bool _hasLoadedBeginner = false;

  // Getters
  List<GroupExercise> get beginnerList => _beginnerList;
  bool get isLoading => _isLoading;

  // ✅ Trả ra danh sách item theo group hiện tại
  List<GroupExerciseItem> getItemList(String groupId) =>
      _groupItemsCache[groupId] ?? [];

  /// 🔹 Lấy danh sách group exercise theo level
  Future<void> fetchBeginnerExercises({int? limitCount}) async {
    if (_hasLoadedBeginner) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getGroupExercisesByLevel(
        level: 'Beginner',
        limitCount: limitCount,
      );

      if (limitCount != null && limitCount > 0 && result.length > limitCount) {
        _beginnerList = result.take(limitCount).toList();
      } else {
        _beginnerList = result;
      }

      _hasLoadedBeginner = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Lỗi khi tải beginner exercises: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Lấy danh sách item theo groupId (có cache)
  Future<void> fetchItemGroupExercises(String groupId) async {
    // ✅ Nếu đã có trong cache thì khỏi gọi lại Supabase
    if (_groupItemsCache.containsKey(groupId)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final items = await _service.getGroupExerciseItems(groupId);
      _groupItemsCache[groupId] = items;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Lỗi khi tải item group exercises ($groupId): $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Làm mới danh sách item của group (bắt Supabase load lại)
  Future<void> refreshItemGroupExercises(String groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final items = await _service.getGroupExerciseItems(groupId);
      _groupItemsCache[groupId] = items;
    } catch (e) {
      debugPrint('❌ Lỗi khi refresh item group exercises ($groupId): $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Xóa cache (nếu cần reset toàn bộ)
  void clearCache() {
    _groupItemsCache.clear();
    _hasLoadedBeginner = false;
    notifyListeners();
  }

  String totaltime(String groupId) {
    final data = _groupItemsCache[groupId];
    if (data == null || data.isEmpty) return "0 phút";

    // Tính tổng thời gian (giây) và tổng calories
    int totalSeconds = 0;

    for (var item in data) {
      // mỗi bài tập: (reps * sets * durationSeconds)
      totalSeconds += (item.repetitions * item.sets * item.durationSeconds);
    }

    // Đổi sang phút (làm tròn)
    final totalMinutes = (totalSeconds / 60).ceil();

    return "$totalMinutes";
  }

  String getTotalcalo(String groupId) {
    final data = _groupItemsCache[groupId];
    if (data == null || data.isEmpty) return " 0 kcal";

    double totalCalories = 0;

    for (var item in data) {
      // calories cũng tương tự: (caloPerRep * reps * sets)
      totalCalories +=
          (item.caloriesPerRep ?? 0) * item.repetitions * item.sets;
    }

    return "${totalCalories.round()}";
  }
  /// 🔹 Chèn bài "nghỉ" động giữa các bài tập
  ///  - Nghỉ 20s giữa các bài tập
  ///  - Nghỉ 15s giữa các set (nếu cần)
  List<GroupExerciseItem> insertRestItems(List<GroupExerciseItem> originalList) {
    final List<GroupExerciseItem> result = [];

    for (int i = 0; i < originalList.length; i++) {
      final exercise = originalList[i];

      // 🔹 Thêm từng set, sau mỗi set (trừ set cuối) có bài nghỉ 15s
      for (int s = 0; s < exercise.sets; s++) {
        result.add(
          GroupExerciseItem(
            itemId: "${exercise.itemId}_set${s + 1}",
            orderNumber: exercise.orderNumber,
            sets: exercise.sets,
            repetitions: exercise.repetitions,
            durationSeconds: exercise.durationSeconds,
            exerciseId: exercise.exerciseId,
            exerciseName: "${exercise.exerciseName} (Set ${s + 1})",
            description: exercise.description,
            caloriesPerRep: exercise.caloriesPerRep,
            mediaUrl: exercise.mediaUrl,
          ),
        );

        // 🔹 Nghỉ giữa các set
        if (s < exercise.sets - 1) {
          result.add(
            GroupExerciseItem(
              itemId: "rest_set_${exercise.itemId}_$s",
              orderNumber: null,
              sets: 0,
              repetitions: 0,
              durationSeconds: 15, // nghỉ giữa các set
              exerciseId: "rest",
              exerciseName: "Rest Between Sets",
              description: "Take a 15s break before next set",
              caloriesPerRep: 0,
              mediaUrl: null,
            ),
          );
        }
      }

      // 🔹 Nghỉ giữa các bài
      if (i < originalList.length - 1) {
        result.add(
          GroupExerciseItem(
            itemId: "rest_exercise_$i",
            orderNumber: null,
            sets: 0,
            repetitions: 0,
            durationSeconds: 20, // nghỉ giữa bài tập
            exerciseId: "rest",
            exerciseName: "Rest Between Exercises",
            description: "Take a 20s break before next exercise",
            caloriesPerRep: 0,
            mediaUrl: null,
          ),
        );
      }
    }

    return result;
  }

  

}


