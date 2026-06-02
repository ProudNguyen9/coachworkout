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

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/37800970-7810-4691-a975-b82e481a21df" />
  <img width="220" src="https://github.com/user-attachments/assets/ab4ba781-79bc-4cbd-8fac-ce6ffffd35e0" />
  <img width="220" src="https://github.com/user-attachments/assets/ee38131b-4425-424c-b3d9-61356c2c2a4c" />
</p>

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/d2d2d6df-0531-4ed0-9bc1-b7a4c4c545c7" />
  <img width="220" src="https://github.com/user-attachments/assets/167675bb-e8ae-4104-8052-8b2a01af0350" />
  <img width="220" src="https://github.com/user-attachments/assets/a5eb3431-b50b-4422-91ad-5c0dbdb98a79" />
</p>

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/15907027-8631-442b-9871-bf6784e27cea" />
  <img width="220" src="https://github.com/user-attachments/assets/ba62ff5f-3710-4697-a8da-ab110a78f20d" />
  <img width="220" src="https://github.com/user-attachments/assets/1b121044-6990-45dc-80d1-fa5450eb21a0" />
</p>

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/1f051126-c503-4526-8999-5800decec1b8" />
  <img width="220" src="https://github.com/user-attachments/assets/067ffe77-5432-4128-9569-3fc934385e0f" />
  <img width="220" src="https://github.com/user-attachments/assets/93bc7037-7746-4799-9d0d-d020aaa841af" />
</p>

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/b7c0486a-d271-4c29-a379-da937f315379" />
  <img width="220" src="https://github.com/user-attachments/assets/afe64c98-3907-46e3-a006-ffb5107c082d" />
  <img width="220" src="https://github.com/user-attachments/assets/0081bcab-e867-451a-8351-2fd537943faf" />
</p>

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/a9afe6a8-70ca-42ad-83e8-f2e0b2244fb9" />
  <img width="220" src="https://github.com/user-attachments/assets/5f345d51-b4f3-444b-a8a2-059a21234952" />
</p>

