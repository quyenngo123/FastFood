# 🍔 FastFood App - Flutter Project

Dự án ứng dụng đặt đồ ăn nhanh hiện đại, áp dụng cấu trúc **Clean Architecture** và các tiêu chuẩn UI/UX mới nhất. Ứng dụng tích hợp hệ thống quản lý trạng thái chuyên nghiệp và kết nối thời gian thực với Firebase.

## 🌟 Tính năng nổi bật & UI/UX

### 1. Hệ thống Yêu thích (Favorite System)
- **Tương tác mượt mà**: Biểu tượng trái tim trắng (🤍) trên nền mờ, tự động chuyển sang đỏ rực (❤️) khi tap.
- **Trang Yêu thích riêng biệt**: Quản lý danh sách món ăn quan tâm, tích hợp ngay trong thanh điều hướng chính.

### 2. Thiết kế Voucher "Vé giảm giá" (Ticket Design)
- **UI sáng tạo**: Sử dụng `CustomClipper` tạo vết cắt bán nguyệt và `CustomPainter` vẽ đường kẻ đứt quãng (Dashed Line) tạo hiệu ứng tấm vé thật.
- **Trạng thái thông minh**: Tự động phân loại voucher: *Dùng ngay*, *Chưa đủ điều kiện (đơn tối thiểu)*, *Hết hạn* (tự động xám hóa).

### 3. Food Page & Giỏ hàng đồng bộ
- **Header hiện đại**: Header màu xanh Primary đặc trưng với bo góc lớn (30px), tích hợp Badge giỏ hàng thời gian thực.
- **Smart Image Loading**: Cơ chế tự động nhận diện và hiển thị ảnh từ **Firebase URL** hoặc **Local Assets**, tích hợp fallback khi link lỗi.
- **Lọc món ăn**: Thanh filter linh hoạt theo danh mục (Pizza, Burger, Lẩu, Ăn vặt...).

### 4. Navigation mượt mà
- **IndexedStack Navigation**: Chuyển đổi giữa các Tab (Trang chủ, Khám phá, Yêu thích) tức thì, giữ nguyên trạng thái cuộn của người dùng.
- **GoRouter**: Hệ thống định tuyến mạnh mẽ, xử lý chuyển trang và truyền dữ liệu (Extra) chuyên nghiệp.

## 🚀 Công nghệ sử dụng

*   **State Management:** `Flutter Bloc (v9.0.0)` - Quản lý logic tách biệt hoàn toàn khỏi UI.
*   **Dependency Injection:** `GetIt` - Service Locator để khởi tạo tập trung các DataSources, Repositories, UseCases.
*   **Backend:** `Firebase (Auth, Cloud Firestore)`.
*   **Architecture:** `Clean Architecture` (Data -> Domain -> Presentation).
*   **UI Components:** `Custom Clippers`, `Custom Painters`, `Animated Containers`.

## 📂 Cấu trúc dự án

```text
lib/
├── config/                 # Routes (AppRouter, AppRoutes)
├── core/                   # Theme (AppColors), Firebase Seeding, Utils
├── features/               # Các tính năng (Clean Architecture)
│   ├── auth/               # Login, Register, Profile
│   ├── food/               # Food Page, Cart, Voucher, Favorite
│   ├── home/               # Banner, Notification
│   └── orders/             # Checkout, History, Order Detail
├── shared/                 # Widgets dùng chung (FoodCard...)
└── injection_container.dart # Nơi đăng ký mọi Dependency (DI)
```

## 🔥 Firestore Collections (12 chính)

Hệ thống dữ liệu đã được chuẩn hóa cho 12 collection:
`Users`, `Addresses`, `Foods`, `Categories`, `Combos`, `Vouchers`, `Favorites`, `Carts`, `Orders`, `Reviews`, `Banners`, `Notifications`.

## 🛠 Hướng dẫn cài đặt

1.  **Lấy source code & Cài đặt thư viện:**
    ```bash
    flutter pub get
    ```
2.  **Cấu hình Firebase:**
    Đảm bảo project đã được cấu hình Firebase thông qua FlutterFire CLI.
3.  **Khởi tạo dữ liệu (Seeding):**
    Mở thư mục `lib/core/firebase/` để xem các tập lệnh khởi tạo dữ liệu mẫu lên Firestore của bạn.
4.  **Chạy ứng dụng:**
    ```bash
    flutter run
    ```

---
*Dự án đang được phát triển tích cực với các bản cập nhật UI hàng ngày.*
