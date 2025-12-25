import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import '../screens.dart';

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
              // 🔹 Phần mở đầu
              Text(
                'Your Coaches',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get trained by the best — connect, chat, and follow your favorite coach!',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 12),

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

              // 🔹 Phần gợi ý huấn luyện viên
              _SectionHeader(
                title: "Coaches You May Like",
                subtitle: "Discover new trainers and styles to explore",
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
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
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
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00FF9C), Color(0xFF007BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_outlined, size: 16),
                            label: const Text("Chat"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
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
                                      const CoachProfileScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              isSuggested
                                  ? Icons.add_rounded
                                  : Icons.favorite_border,
                              size: 16,
                            ),
                            label: const Text("Profile"),
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
