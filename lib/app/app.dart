import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../config/config.dart';
import '../config/theme/flutter_dash.dart';

class CoachWorkout extends StatelessWidget {
  const CoachWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.watch<RoutesNotifier>().router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // 🔥 BẮT BUỘC CHO ĐA NGÔN NGỮ
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      title: 'Coach Workout',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      routerConfig: router,
    );
  }
}
