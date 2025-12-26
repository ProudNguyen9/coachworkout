import 'package:coach_workout/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool locationEnabled = true;
  bool darkMode = false;
  bool pushNotifications = true;
  bool emailNotifications = true;

  late String _language; // vi | en

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔥 LẤY NGÔN NGỮ HIỆN TẠI CỦA APP
    _language = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'settings.title'.tr(),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xff151111),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _sectionHeader('settings.general'.tr()),

          /// 🌐 NGÔN NGỮ
          _settingItem(
            'settings.language'.tr(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _language == 'vi' ? '🇻🇳 Tiếng Việt' : '🇬🇧 English',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const Gap(6),
                const Icon(Icons.chevron_right, color: Colors.black45),
              ],
            ),
            onTap: _showLanguagePicker,
          ),

          _settingItem('settings.edit_profile'.tr()),

          _switchItem('settings.location'.tr(), locationEnabled, (v) {
            setState(() => locationEnabled = v);
          }),

          const Gap(10),

          _switchItem('settings.dark_mode'.tr(), darkMode, (v) {
            setState(() => darkMode = v);
          }),

          const SizedBox(height: 16),
          _sectionHeader('settings.notifications'.tr()),

          _switchItem('settings.push_notifications'.tr(), pushNotifications, (
            v,
          ) {
            setState(() => pushNotifications = v);
          }),

          const Gap(10),

          _switchItem('settings.email_notifications'.tr(), emailNotifications, (
            v,
          ) {
            setState(() => emailNotifications = v);
          }),

          const SizedBox(height: 16),
          _sectionHeader('settings.support'.tr()),

          _settingItem('settings.contact_support'.tr()),
          _settingItem('settings.rate_app'.tr()),
          _settingItem('settings.terms'.tr()),

          const SizedBox(height: 20),

          Center(
            child: TextButton(
              onPressed: () async {
                final supabase = Supabase.instance.client;
                await supabase.auth.signOut();

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              child: Text(
                'settings.logout'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF24BAEC),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================
  // LANGUAGE PICKER
  // ======================
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(12),
            Text(
              'settings.choose_language'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),

            _languageOption(
              flag: '🇻🇳',
              title: 'Tiếng Việt',
              value: 'vi',
              locale: const Locale('vi'),
            ),

            _languageOption(
              flag: '🇬🇧',
              title: 'English',
              value: 'en',
              locale: const Locale('en'),
            ),

            const Gap(12),
          ],
        );
      },
    );
  }

  Widget _languageOption({
    required String flag,
    required String title,
    required String value,
    required Locale locale,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      trailing: _language == value
          ? const Icon(Icons.check, color: Color(0xFF24BAEC))
          : null,
      onTap: () async {
        // 🔥 ĐỔI NGÔN NGỮ TOÀN APP
        await context.setLocale(locale);

        setState(() => _language = value);
        Navigator.pop(context);
      },
    );
  }

  // ======================
  // UI HELPERS
  // ======================
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _settingItem(String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xff151111),
        ),
      ),
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Colors.black45),
    );
  }

  Widget _switchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xff151111),
            ),
          ),
          _customSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _customSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? const Color(0xFF24BAEC) : const Color(0xFFdadada),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1.5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
