import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/workout_streak_service.dart';
import 'app/app.dart'; // file CoachWorkout.dart
import 'config/config.dart';
import 'providers/provider.dart';
import 'config/routes/routes_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('vi');
  await initializeDateFormatting('en');

  await WorkoutStreakService.init();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'Missing Supabase config. Run with --dart-define-from-file=env.json '
      'or pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

  // ✅ Khởi tạo Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await LocalNotificationService.instance.init();
  await LocalNotificationService.instance.syncTodayWorkoutReminders();

  // ✅ Ẩn thanh trạng thái
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // ✅ MultiProvider
  final container = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PasswordProvider()),
      ChangeNotifierProvider(create: (_) => TabProvider()),
      ChangeNotifierProvider(create: (_) => RoutesNotifier()),
      ChangeNotifierProvider(create: (_) => GroupExerciseProvider()),
    ],
    child: GestureDetector(
      behavior: HitTestBehavior.translucent, // bắt sự kiện tap trên vùng trống
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // ẩn bàn phím
      },
      child: const CoachWorkout(),
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      child: container,
    ),
  );
}
