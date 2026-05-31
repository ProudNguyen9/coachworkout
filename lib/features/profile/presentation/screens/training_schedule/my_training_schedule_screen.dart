import 'package:coach_workout/core/services/supabase_service.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyTrainingScheduleScreen extends StatefulWidget {
  const MyTrainingScheduleScreen({super.key});

  @override
  State<MyTrainingScheduleScreen> createState() =>
      _MyTrainingScheduleScreenState();
}

class _MyTrainingScheduleScreenState extends State<MyTrainingScheduleScreen> {
  late Future<List<Map<String, dynamic>>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() {
    _schedulesFuture = SupabaseService().getMyTrainingSchedules();
  }

  Future<void> _refreshSchedules() async {
    setState(_loadSchedules);
    await _schedulesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lịch luyện tập của tôi',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSchedules,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _schedulesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _MessageState(
                icon: Icons.error_outline,
                title: 'Không thể tải lịch tập',
                message: '${snapshot.error}',
              );
            }

            final schedules = snapshot.data ?? [];
            if (schedules.isEmpty) {
              return const _MessageState(
                icon: Icons.calendar_month_outlined,
                title: 'Chưa có lịch luyện tập',
                message:
                    'Hãy vào một bài tập, chọn ngày trong phần Lịch luyện tập rồi bấm lưu.',
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              separatorBuilder: (_, __) => const Gap(14),
              itemBuilder: (context, index) {
                return _ScheduleCard(schedule: schedules[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.schedule});

  final Map<String, dynamic> schedule;

  @override
  Widget build(BuildContext context) {
    final course = schedule['course'] as Map<String, dynamic>?;
    final days = (schedule['days'] as List? ?? [])
        .map((day) => Map<String, dynamic>.from(day as Map))
        .toList();
    final completedDays = days.where((day) => day['completed'] == true).length;
    final title = course?['title']?.toString() ?? 'Lịch tập của tôi';
    final level = course?['level']?.toString() ?? 'Beginner';
    final startDate = _formatDate(schedule['start_date']);

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: context.colorScheme.primary,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Cấp độ: $level • Bắt đầu: $startDate',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(14),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: days.isEmpty ? 0 : completedDays / days.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colorScheme.primary,
                ),
              ),
            ),
            const Gap(8),
            Text(
              'Hoàn thành $completedDays/${days.length} ngày',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const Gap(12),
            ...days.map((day) => _ScheduleDayTile(day: day)),
          ],
        ),
      ),
    );
  }

  static String _formatDate(dynamic value) {
    if (value == null) return '--/--/----';
    final date = DateTime.tryParse(value.toString());
    if (date == null) return '--/--/----';
    return DateFormat('dd/MM/yyyy', 'vi').format(date.toLocal());
  }
}

class _ScheduleDayTile extends StatelessWidget {
  const _ScheduleDayTile({required this.day});

  final Map<String, dynamic> day;

  @override
  Widget build(BuildContext context) {
    final completed = day['completed'] == true;
    final dayNumber = day['course_day_number']?.toString() ?? '-';
    final plannedDate = _formatDate(day['planned_date']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
            size: 22,
          ),
          const Gap(10),
          Expanded(
            child: Text(
              'Ngày $dayNumber • $plannedDate',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            completed ? 'Đã tập' : 'Chưa tập',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: completed ? Colors.green : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(dynamic value) {
    if (value == null) return '--/--/----';
    final date = DateTime.tryParse(value.toString());
    if (date == null) return '--/--/----';
    return DateFormat('EEEE, dd/MM/yyyy', 'vi').format(date.toLocal());
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const Gap(120),
        Icon(icon, size: 64, color: Colors.grey.shade500),
        const Gap(16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const Gap(8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
