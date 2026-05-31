# Coach Workout

Coach Workout là ứng dụng Flutter hỗ trợ tập luyện cá nhân, theo dõi lịch tập, streak, bài tập theo nhóm cơ và AI Coach. Ứng dụng dùng Supabase để quản lý xác thực, hồ sơ người dùng, dữ liệu bài tập và lịch tập; đồng thời tích hợp AI API tương thích OpenAI để tư vấn tập luyện, dinh dưỡng và phục hồi.

## Tính năng chính

- Đăng nhập/đăng ký và lưu hồ sơ người dùng với Supabase.
- Onboarding nhập thông tin cá nhân ban đầu như giới tính, tuổi, chiều cao, cân nặng và mục tiêu.
- Trang chủ hiển thị tổng quan luyện tập, bài tập beginner và lịch tập hôm nay.
- Danh sách bài tập lấy từ database, có ảnh/video minh họa và fallback khi video local không tồn tại.
- Tạo lịch luyện tập cá nhân theo ngày được chọn và lưu lên Supabase.
- Trang “Lịch luyện tập của tôi” để xem lịch đã lưu.
- Lịch/streak luyện tập: đánh dấu ngày đã tập, ngày có lịch và ngày nghỉ.
- Local notification nhắc tập vào 08:00, 12:00, 15:00 và 18:00 nếu hôm đó có lịch nhưng chưa hoàn thành.
- AI Coach cá nhân hỗ trợ hỏi đáp về fitness, yoga, dinh dưỡng, phục hồi, giảm cân và tăng cơ.
- Hỗ trợ đa ngôn ngữ qua Easy Localization.
- Giao diện Flutter hiện đại, có bottom navigation và nhiều widget tái sử dụng.

## Công nghệ sử dụng

- Flutter SDK / Dart
- Supabase Flutter
- Provider
- GoRouter
- Hive Flutter
- Easy Localization
- Flutter Local Notifications
- Timezone
- Video Player
- Cached Network Image
- Syncfusion DatePicker/Charts
- Zego UIKit Prebuilt Call
- HTTP / Dio
- Image Picker

## Cấu trúc thư mục

```text
lib/
├── app/                         # Cấu hình app chính
├── config/                      # Routes, theme và cấu hình chung
├── core/services/               # Supabase, streak, notification service
├── features/                    # Các module tính năng chính
│   ├── auth/                    # Đăng nhập/đăng ký
│   ├── chat/                    # AI Coach
│   ├── home/                    # Trang chủ và overview
│   ├── onboarding/              # Thiết lập hồ sơ ban đầu
│   ├── profile/                 # Hồ sơ người dùng
│   ├── root/                    # Root screen / bottom navigation
│   └── workout/                 # Bài tập, lịch tập, phiên tập
├── providers/                   # Provider tổng hợp
├── shared/widgets/              # Widget dùng chung
├── utils/                       # Helper, extension, validator
└── main.dart                    # Entry point

assets/
├── translations/                # File ngôn ngữ en/vi
├── icons/                       # Icon SVG/JPG
├── images/                      # Ảnh dụng cụ/bài tập
└── libraryworkout/              # Ảnh nhóm cơ
```

## Yêu cầu môi trường

- Flutter SDK tương thích Dart `^3.8.1`.
- Android Studio hoặc VS Code có Flutter/Dart extension.
- Android SDK nếu chạy Android.
- Xcode nếu chạy iOS/macOS.
- Một project Supabase đã có schema/table phù hợp với app.

Kiểm tra môi trường:

```bash
flutter doctor
```

## Cài đặt và chạy dự án

1. Clone source code:

```bash
git clone <repository-url>
cd coach_workout
```

2. Cài dependency:

```bash
flutter pub get
```

3. Chạy app:

```bash
flutter run
```

4. Build Android APK:

```bash
flutter build apk
```

5. Build Android App Bundle:

```bash
flutter build appbundle
```

## Cấu hình Supabase

Supabase được khởi tạo trong `lib/main.dart` bằng `Supabase.initialize(...)`.

Bạn cần đảm bảo các thông tin sau đúng với project Supabase của mình:

- `url`: URL project Supabase.
- `anonKey`: Publishable/anon key.
- Các bảng dữ liệu bài tập, lịch tập, hồ sơ người dùng đã được tạo đúng schema.

Các service chính liên quan Supabase nằm tại:

- `lib/core/services/supabase_service.dart`
- `lib/core/services/workout_streak_service.dart`

> Lưu ý: Khi đưa app lên production, không nên hardcode key trực tiếp trong source. Nên chuyển sang file cấu hình môi trường hoặc cơ chế secret/config an toàn hơn.

## Cấu hình AI Coach

AI Coach nằm trong:

- `lib/features/chat/presentation/screens/custom_chat/custom_chat_screen.dart`

Ứng dụng hiện gọi API theo chuẩn OpenAI-compatible endpoint:

- Base URL dạng `/v1`
- Endpoint `/chat/completions`
- Model: `gpt-5.5`
- Authorization Bearer token

AI Coach được ràng buộc chỉ trả lời các chủ đề phù hợp:

- Tập luyện, kỹ thuật bài tập, set/reps/thời gian nghỉ.
- Gym, fitness, cardio, HIIT, yoga, pilates, giãn cơ.
- Dinh dưỡng thể thao, calo, macro, thực đơn.
- Phục hồi sau tập, ngủ, warm-up/cool-down.
- Lập kế hoạch giảm cân, tăng cơ, giữ dáng, sức bền.

AI không thay thế bác sĩ/chuyên gia y tế và sẽ khuyên người dùng đi khám nếu có dấu hiệu nguy hiểm như đau ngực, khó thở, chấn thương nặng hoặc chóng mặt.

> Lưu ý bảo mật: API key AI nên được đưa ra khỏi source code trước khi phát hành chính thức.

## Local Notification

Ứng dụng dùng `flutter_local_notifications` và `timezone` để nhắc tập luyện.

Logic hiện tại:

- Múi giờ mặc định: `Asia/Ho_Chi_Minh`.
- Các khung giờ nhắc: 08:00, 12:00, 15:00, 18:00.
- Chỉ nhắc nếu ngày đó có lịch tập.
- Không nhắc nếu người dùng đã hoàn thành lịch tập hôm đó.
- Khi tạo lịch mới, app đồng bộ lại notification.
- Khi hoàn thành bài tập, app hủy notification còn lại trong ngày.

File chính:

- `lib/core/services/local_notification_service.dart`

### Android permission

Android manifest đã khai báo quyền notification:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

File liên quan:

- `android/app/src/main/AndroidManifest.xml`

### Android desugaring

`flutter_local_notifications` cần core library desugaring. Cấu hình đã được bật trong:

- `android/app/build.gradle.kts`

```kotlin
compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

## Đa ngôn ngữ

Ứng dụng dùng `easy_localization`.

File ngôn ngữ:

- `assets/translations/en.json`
- `assets/translations/vi.json`

Khi thêm text mới, nên cập nhật cả hai file để tránh thiếu key dịch.

## Assets

Assets chính được khai báo trong `pubspec.yaml` gồm:

- `assets/`
- `assets/icons/`
- `assets/images/`
- `assets/libraryworkout/`
- `assets/translations/`

Sau khi thêm asset mới, chạy:

```bash
flutter pub get
```

## Kiểm tra chất lượng code

Chạy phân tích code:

```bash
flutter analyze
```

Chạy test:

```bash
flutter test
```

Format code:

```bash
dart format .
```

## Ghi chú phát triển

- Không commit API key hoặc secret production lên repository công khai.
- Nếu đổi host Supabase Storage, cần cập nhật URL trong database cho các cột ảnh/video liên quan.
- Nếu video local không tồn tại, app sẽ fallback sang network URL khi có dữ liệu.
- Nếu notification không hiện trên Android 13+, hãy kiểm tra quyền thông báo của app trong Settings.
- Nếu AI API trả redirect, app đã có xử lý retry với các status `308`, `301`, `302`.

## License

Dự án phục vụ mục đích học tập và phát triển ứng dụng workout cá nhân. Cập nhật license phù hợp trước khi phát hành công khai.
