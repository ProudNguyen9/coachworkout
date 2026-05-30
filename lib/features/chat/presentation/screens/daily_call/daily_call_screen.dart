import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  final String userId;
  final String callId;

  const VideoCallScreen({
    super.key,
    required this.userId,
    required this.callId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 1573251683, // 🔹 Dán AppID của bạn ở đây
        appSign: "b4fec1c0f3763ccd8af838c5f4bc402c071616be7f55908ed6a03c2bd8009f17", // 🔹 Dán AppSign của bạn ở đây
        userID: userId,
        userName: "User $userId",
        callID: callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}


