import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const String _oldSupabaseStorageBaseUrl =
    'https://zsqeewnrycesouhunxxk.supabase.co/storage/v1/object/public';
const String _newSupabaseStorageBaseUrl =
    'https://kqlonwcsjrirgmeddoze.supabase.co/storage/v1/object/public';

String _normalizeStorageUrl(String url) {
  if (url.isEmpty) return url;
  return url.replaceFirst(
    _oldSupabaseStorageBaseUrl,
    _newSupabaseStorageBaseUrl,
  );
}

Widget buildImageCard(BuildContext context, String imageUrl, String title) {
  final normalizedImageUrl = _normalizeStorageUrl(imageUrl);

  return GestureDetector(
    onTap: () {},
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            normalizedImageUrl,
            width: 240,
            height: 170,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 240,
                height: 170,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: 42,
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 5)],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'time.minute_value'.tr(args: ['11']),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
