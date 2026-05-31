const String _oldSupabaseStorageBaseUrl =
    'https://zsqeewnrycesouhunxxk.supabase.co/storage/v1/object/public';
const String _newSupabaseStorageBaseUrl =
    'https://kqlonwcsjrirgmeddoze.supabase.co/storage/v1/object/public';

String? _normalizeStorageUrl(String? url) {
  if (url == null || url.isEmpty) return url;
  return url.replaceFirst(
    _oldSupabaseStorageBaseUrl,
    _newSupabaseStorageBaseUrl,
  );
}

class GroupExerciseItem {
  final String itemId;
  final int? orderNumber;
  final int sets;
  final int repetitions;
  final int durationSeconds;
  final String exerciseId;
  final String exerciseName;
  final String? description;
  final double? caloriesPerRep;
  final String? mediaUrl;

  GroupExerciseItem({
    required this.itemId,
    required this.orderNumber,
    required this.sets,
    required this.repetitions,
    required this.durationSeconds,
    required this.exerciseId,
    required this.exerciseName,
    this.description,
    this.caloriesPerRep,
    this.mediaUrl,
  });

  /// Parse JSON → Object
  factory GroupExerciseItem.fromJson(Map<String, dynamic> json) {
    return GroupExerciseItem(
      itemId: json['item_id'] as String,
      orderNumber: json['order_number'] as int,
      sets: json['sets'] as int,
      repetitions: json['repetitions'] as int,
      durationSeconds: json['duration_seconds'] as int,
      exerciseId: json['exercise_id'] as String,
      exerciseName: json['exercise_name'] as String,
      description: json['description'] as String?,
      caloriesPerRep: (json['calories_per_rep'] != null)
          ? (json['calories_per_rep'] as num).toDouble()
          : null,
      mediaUrl: _normalizeStorageUrl(json['media_url'] as String?),
    );
  }

  /// Convert Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'order_number': orderNumber,
      'sets': sets,
      'repetitions': repetitions,
      'duration_seconds': durationSeconds,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'description': description,
      'calories_per_rep': caloriesPerRep,
      'media_url': _normalizeStorageUrl(mediaUrl),
    };
  }

  /// Optional: tiện hơn khi debug/log
  @override
  String toString() {
    return 'GroupExerciseItem($exerciseName - $sets sets x $repetitions reps)';
  }
}
