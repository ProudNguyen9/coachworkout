import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart'; // file CoachWorkout.dart
import 'config/config.dart';
import 'providers/provider.dart';
import 'config/routes/routes_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Khởi tạo Supabase
  await Supabase.initialize(
    url: 'https://zsqeewnrycesouhunxxk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzcWVld25yeWNlc291aHVueHhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3Mjc2NDMsImV4cCI6MjA3NjMwMzY0M30.NT9XbVC0astMhOuqxZtqv03Nh4t3c1eV2uo6b0AY5Wg',
  );

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

  runApp(container);
}
