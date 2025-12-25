import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ===============================
/// MODEL
/// ===============================
class Coach {
  final String name;
  final String title;
  final double rating;
  final int reviews;
  final String bio;
  final double pricePerSession;
  final String avatar;

  Coach({
    required this.name,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.bio,
    required this.pricePerSession,
    required this.avatar,
  });
}

/// ===============================
/// TIME SLOT MODEL
/// ===============================
class TimeSlot {
  final int start;
  final int end;

  const TimeSlot(this.start, this.end);

  @override
  String toString() => '$start-$end';
}

/// ===============================
/// SCREEN
/// ===============================
class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({super.key});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  final Coach coach = Coach(
    name: 'Nguyen Doanh',
    title: 'Certified Personal Trainer',
    rating: 4.9,
    reviews: 120,
    bio:
        '8+ years experience in weight loss, muscle building and home workout programs.',
    pricePerSession: 10,
    avatar: 'assets/doanh.png',
  );

  final DateTime today = DateTime.now();
  DateTime currentMonth = DateTime.now();

  /// ===============================
  /// TIME SLOTS (7–8, 8–9, ...)
  /// ===============================
  final List<TimeSlot> timeSlots = const [
    TimeSlot(7, 8),
    TimeSlot(8, 9),
    TimeSlot(9, 10),
    TimeSlot(10, 11),
    TimeSlot(13, 14),
    TimeSlot(14, 15),
    TimeSlot(15, 16),
    TimeSlot(16, 17),
  ];

  final Set<String> busySlots = {};
  final Set<String> selectedSlots = {};

  @override
  void initState() {
    super.initState();

    /// MOCK BUSY SLOTS
    busySlots.add(_slotKey(today, const TimeSlot(8, 9)));
    busySlots.add(
      _slotKey(today.add(const Duration(days: 1)), const TimeSlot(14, 15)),
    );
    busySlots.add(
      _slotKey(today.add(const Duration(days: 2)), const TimeSlot(9, 10)),
    );
  }

  String _slotKey(DateTime date, TimeSlot slot) {
    return '${DateFormat('yyyy-MM-dd').format(date)}-${slot.start}-${slot.end}';
  }

  /// ===============================
  /// DAYS IN MONTH (FROM TODAY)
  /// ===============================
  List<DateTime> get daysInMonth {
    final first = DateTime(currentMonth.year, currentMonth.month, 1);
    final last = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    return List.generate(last.day, (i) {
      final day = first.add(Duration(days: i));
      return day.isBefore(DateTime(today.year, today.month, today.day))
          ? null
          : day;
    }).whereType<DateTime>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'Coach Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _coachInfo(),
            const SizedBox(height: 20),
            _aboutCoach(),
            const SizedBox(height: 24),
            _monthSwitcher(),
            const SizedBox(height: 12),
            _scheduleTable(),
            const SizedBox(height: 28),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// COACH INFO
  /// ===============================
  Widget _coachInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: const Color(0xffE0E7FF),
          backgroundImage: AssetImage(coach.avatar),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coach.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(coach.title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('${coach.rating} (${coach.reviews} reviews)'),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '\$${coach.pricePerSession.toStringAsFixed(0)} / hour',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ===============================
  /// ABOUT
  /// ===============================
  Widget _aboutCoach() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Coach',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(coach.bio, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// ===============================
  /// MONTH SWITCHER
  /// ===============================
  Widget _monthSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              currentMonth = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
              );
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(currentMonth),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              currentMonth = DateTime(
                currentMonth.year,
                currentMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  /// ===============================
  /// SCHEDULE TABLE (TIME SLOT BASED)
  /// ===============================
  Widget _scheduleTable() {
    final days = daysInMonth.take(7).toList();

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 64),
            ...days.map(
              (d) => Expanded(
                child: Column(
                  children: [
                    Text(
                      DateFormat('E').format(d),
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      DateFormat('dd').format(d),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...timeSlots.map((slot) {
          return Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  '${slot.start}-${slot.end}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              ...days.map((date) {
                final key = _slotKey(date, slot);
                final isBusy = busySlots.contains(key);
                final isSelected = selectedSlots.contains(key);

                return Expanded(
                  child: GestureDetector(
                    onTap: isBusy
                        ? null
                        : () {
                            setState(() {
                              isSelected
                                  ? selectedSlots.remove(key)
                                  : selectedSlots.add(key);
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      height: 28,
                      decoration: BoxDecoration(
                        color: isBusy
                            ? const Color(0xffFEE2E2)
                            : isSelected
                            ? context.colorScheme.secondary
                            : const Color(0xffDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  /// ===============================
  /// ACTION BUTTONS
  /// ===============================
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: context.colorScheme.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Consult',
              style: TextStyle(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedSlots.isNotEmpty ? () {} : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: context.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Book Session',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
