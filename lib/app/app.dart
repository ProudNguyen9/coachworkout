import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/config.dart';
import '../config/theme/flutter_dash.dart';

class CoachWorkout extends StatelessWidget {
  const CoachWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.watch<RoutesNotifier>().router;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Workout App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
