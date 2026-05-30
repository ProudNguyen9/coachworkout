import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const CachedVideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<CachedVideoPlayerWidget> createState() =>
      _CachedVideoPlayerWidgetState();
}

class _CachedVideoPlayerWidgetState extends State<CachedVideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    // Dùng cache manager để lấy file (tự động cache nếu đã tải)
    final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller!.play();
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller!),
          VideoProgressIndicator(_controller!, allowScrubbing: true),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


