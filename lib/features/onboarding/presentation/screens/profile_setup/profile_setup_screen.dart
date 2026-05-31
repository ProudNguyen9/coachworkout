import 'package:coach_workout/config/routes/routes_location.dart';
import 'package:coach_workout/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupScreen extends StatefulWidget {
  final double weight;
  final int age;
  final double height;

  static ProfileSetupScreen builder(BuildContext context, GoRouterState state) {
    final query = state.uri.queryParameters;
    return ProfileSetupScreen(
      weight: double.tryParse(query['weight'] ?? '') ?? 39.8,
      age: int.tryParse(query['age'] ?? '') ?? 20,
      height: double.tryParse(query['height'] ?? '') ?? 170.5,
    );
  }

  const ProfileSetupScreen({
    super.key,
    required this.weight,
    required this.age,
    required this.height,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nicknameController = TextEditingController();
  final _aboutMeController = TextEditingController();
  bool isFemaleSelected = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileAndContinue() async {
    final supabase = Supabase.instance.client;
    final authUser = supabase.auth.currentUser;

    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập trước khi lưu hồ sơ.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final nickname = _nicknameController.text.trim();
      final aboutMe = _aboutMeController.text.trim();
      final avatarUrl = isFemaleSelected
          ? 'assets/female.png'
          : 'assets/male.png';
      final displayName = nickname.isNotEmpty
          ? nickname
          : authUser.userMetadata?['name']?.toString();

      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'nickname': nickname,
            'about_me': aboutMe,
            'gender': isFemaleSelected ? 'female' : 'male',
            'weight': widget.weight,
            'age': widget.age,
            'height': widget.height,
            'onboarding_completed': true,
          },
        ),
      );

      await supabase.from('users').upsert({
        'id': authUser.id,
        'email': authUser.email ?? '',
        'name': displayName,
        'role': 'student',
        'avatar_url': avatarUrl,
        'is_online': true,
        'last_seen': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      context.go(RouteLocation.root);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lưu thông tin thất bại: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              Center(
                child: Text(
                  'ProfileSetupScreen.personal_info_title'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(10),
              Text(
                'ProfileSetupScreen.personal_info_desc'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const Gap(30),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isFemaleSelected = true;
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 155,
                      decoration: BoxDecoration(
                        color: isFemaleSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: context.colorScheme.primary,
                        ),
                        boxShadow: isFemaleSelected
                            ? [
                                BoxShadow(
                                  color: Colors.cyan[400]!.withValues(
                                    alpha: 0.8,
                                  ),
                                  blurRadius: 12, // nhỏ hơn để bóng rõ nét
                                  spreadRadius: 3, // lan rộng hơn
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Image.asset('assets/female.png'),
                    ),
                  ),
                  const Gap(5),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isFemaleSelected = false;
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 155,
                      decoration: BoxDecoration(
                        color: !isFemaleSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: context.colorScheme.primary,
                        ),
                        boxShadow: !isFemaleSelected
                            ? [
                                BoxShadow(
                                  color: Colors.cyan[400]!.withValues(
                                    alpha: 0.8,
                                  ),
                                  blurRadius: 12, // nhỏ hơn để bóng rõ nét
                                  spreadRadius: 3, // lan rộng hơn
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Image.asset('assets/male.png'),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              Text(
                'ProfileSetupScreen.nickname_label'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: 'ProfileSetupScreen.nickname_hint'.tr(),
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Text(
                'ProfileSetupScreen.about_me_label'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _aboutMeController,
                decoration: InputDecoration(
                  hintText: 'ProfileSetupScreen.about_me_hint'.tr(),
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                maxLines: 2,
                keyboardType: TextInputType.text,
              ),
              const Gap(50),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfileAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[600],
                  foregroundColor: Colors.white,
                  minimumSize: Size(context.deviceSize.width - 50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'ProfileSetupScreen.next_button'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
