import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

class ItemListBeginner extends StatelessWidget {
  final String? path;
  final String? title;
  final String? description;
  final VoidCallback? ontap;

  const ItemListBeginner({
    super.key,
    this.path,
    this.title,
    this.description,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final safePath = _normalizeStorageUrl(
      (path != null && path!.isNotEmpty) ? path! : '',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: ontap ?? () {}, // tránh lỗi null callback
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: safePath.isEmpty
                      ? _fallbackImage()
                      : CachedNetworkImage(
                          imageUrl: safePath,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 65,
                            height: 65,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _fallbackImage(),
                          fadeInDuration: const Duration(milliseconds: 250),
                          memCacheHeight: 300,
                          memCacheWidth: 300,
                        ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? 'Untitled Workout',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description ?? 'No description available',
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(
                        height: 10,
                        thickness: 0.2,
                        color: Colors.grey,
                        indent: 0,
                        endIndent: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 65,
      height: 65,
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: const Icon(Icons.fitness_center, color: Colors.grey),
    );
  }
}
