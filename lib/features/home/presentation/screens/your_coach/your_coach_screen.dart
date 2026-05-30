import 'package:coach_workout/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'package:coach_workout/screen/screens.dart';

class YoursCoach extends StatelessWidget {
  const YoursCoach({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final yourCoaches = [
      {
        'name': 'John Carter',
        'specialty': 'Strength Trainer',
        'avatar': 'https://i.pravatar.cc/300?img=3',
        'background':
            'https://images.unsplash.com/photo-1579758629938-03607ccdbaba?w=800',
      },
      {
        'name': 'Sophia Nguyen',
        'specialty': 'Yoga & Flexibility',
        'avatar': 'https://i.pravatar.cc/300?img=47',
        'background':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
      },
    ];

    final suggestedCoaches = [
      {
        'name': 'Alex Lee',
        'specialty': 'Cardio & HIIT',
        'avatar': 'https://i.pravatar.cc/300?img=56',
        'background':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
      },
      {
        'name': 'Emma Tran',
        'specialty': 'Pilates Expert',
        'avatar': 'https://i.pravatar.cc/300?img=32',
        'background':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrdOI-pFGm7VdHOcUd6oDxmu1KVtpPMRqE_A&s',
      },
      {
        'name': 'Michael Scott',
        'specialty': 'Bodyweight Coach',
        'avatar': 'https://i.pravatar.cc/300?img=65',
        'background':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyaV0bWwrQvU3TKjhtqMbMoXssD23mDFa2g&s',
      },
    ];

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== HEADER =====
              Text(
                'coach.title'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'coach.subtitle'.tr(),
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              /// ===== YOUR COACHES =====
              ...List.generate(yourCoaches.length, (i) {
                final c = yourCoaches[i];
                return FadeInUp(
                  duration: Duration(milliseconds: 300 + i * 100),
                  child: _CoachCard(
                    width: width,
                    name: c['name']!,
                    specialty: c['specialty']!,
                    avatarUrl: c['avatar']!,
                    backgroundUrl: c['background']!,
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// ===== SUGGESTED COACHES =====
              _SectionHeader(
                title: 'coach.suggested_title'.tr(),
                subtitle: 'coach.suggested_subtitle'.tr(),
              ),
              const SizedBox(height: 12),

              ...List.generate(suggestedCoaches.length, (i) {
                final c = suggestedCoaches[i];
                return FadeInUp(
                  duration: Duration(milliseconds: 300 + i * 100),
                  child: _CoachCard(
                    width: width,
                    name: c['name']!,
                    specialty: c['specialty']!,
                    avatarUrl: c['avatar']!,
                    backgroundUrl: c['background']!,
                    isSuggested: true,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// SECTION HEADER
/// ===============================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

/// ===============================
/// COACH CARD
/// ===============================
class _CoachCard extends StatelessWidget {
  final double width;
  final String name;
  final String specialty;
  final String avatarUrl;
  final String backgroundUrl;
  final bool isSuggested;

  const _CoachCard({
    required this.width,
    required this.name,
    required this.specialty,
    required this.avatarUrl,
    required this.backgroundUrl,
    this.isSuggested = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Image.network(
              backgroundUrl,
              width: width,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                /// Avatar
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00FF9C), Color(0xFF007BFF)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                /// Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Actions
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_outlined, size: 16),
                            label: Text('coach.chat'.tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CoachProfile_Booking_Screen(),
                                ),
                              );
                            },
                            icon: Icon(
                              isSuggested
                                  ? Icons
                                        .calendar_month_rounded // Đặt ngay
                                  : Icons.info_outline_rounded, // Thông tin
                              size: 16,
                            ),
                            label: Text(
                              !isSuggested
                                  ? 'coach.profile'.tr()
                                  : 'book_now'.tr(),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.black26),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


