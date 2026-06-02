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
<p align="center">
  <img width="250" src="https://github.com/user-attachments/assets/b366598c-def5-4493-8dcd-b398d4838083" />
  <img width="250" src="https://github.com/user-attachments/assets/f67aaabe-66ef-404e-b070-29b395a48ef9" />
  <img width="250" src="https://github.com/user-attachments/assets/34a46622-2f9c-41a0-bc91-e76508843f05" />
</p>

<p align="center">
  <img width="250" src="https://github.com/user-attachments/assets/f6bf326f-691e-4aff-a3c7-6b06bc036907" />
  <img width="250" src="https://github.com/user-attachments/assets/c73d969b-0819-42e6-ac37-f6bef5874012" />
  <img width="250" src="https://github.com/user-attachments/assets/b056ea52-3b92-4b92-9745-bbf5d8271cd4" />
</p>

<p align="center">
  <img width="250" src="https://github.com/user-attachments/assets/e32d552c-c472-421a-92bf-06c907fa1f38" />
  <img width="250" src="https://github.com/user-attachments/assets/764a6c94-3159-405f-8563-1c7c1e1638c6" />
  <img width="250" src="https://github.com/user-attachments/assets/a8f2ed42-cb11-46ff-b67c-213e99750337" />
</p>
