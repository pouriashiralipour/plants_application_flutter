# 🌿 Full Plants E‑Commerce App (Flutter)

A cross‑platform **Flutter** application for browsing and purchasing plants — designed with a clean UI and a scalable project layout.

---

## ✨ Highlights

- **Plant catalog UI** (browse & explore)
- **Product details** (images, price, description)
- **Cart & checkout flow** (UI-ready)
- **Favorites / wishlist**
- **Search & filtering**
- **Reusable widgets + clean structure**
- **Cross‑platform** (Android / iOS)

---

## 🧱 Tech Stack

- **Flutter** (Dart)
- **Material Design**
- Android + iOS targets

---

## 📁 Project Structure

Typical Flutter layout (as in this repo):

```text
.
├── android/                 # Android native project
├── ios/                     # iOS native project
├── lib/                     # Flutter/Dart source code
├── test/                    # Unit/widget tests
├── pubspec.yaml             # Dependencies + assets
├── pubspec.lock             # Locked dependency versions
├── analysis_options.yaml    # Lints/static analysis rules
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio / Xcode (for platform builds)
- A connected device or emulator

Check your environment:

```bash
flutter doctor
```

### Run locally

```bash
# 1) Install dependencies
flutter pub get

# 2) Run app
flutter run
```

---

## ⚙️ Configuration

If your app consumes a backend API (recommended for a real e‑commerce project), add an environment file and a single place to configure endpoints.

### Option A) Compile-time config (simple)

Create `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8000';
}
```

### Option B) `.env` (recommended)

1) Add dependency:
```bash
flutter pub add flutter_dotenv
```

2) Create `.env`:
```env
API_BASE_URL=http://localhost:8000
```

3) Load it in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
```

> Keep `.env` untracked and commit `.env.example`.

---

## 🔌 Backend Integration (Optional)

If you have a Django REST API (DRF) backend:

- Configure `API_BASE_URL`
- Add authentication (JWT recommended for mobile)
- Implement repository/services:
  - `AuthService` (login/register/token refresh)
  - `CatalogService` (plants/products)
  - `CartService` (cart + checkout)

Suggested endpoints (example):

```text
POST   /api/auth/login/
POST   /api/auth/register/
GET    /api/products/
GET    /api/products/{id}/
POST   /api/cart/items/
GET    /api/cart/
POST   /api/orders/
```

> Replace with your actual routes.

---

## 🧪 Testing & Quality

Run tests:

```bash
flutter test
```

Static analysis:

```bash
dart analyze
```

Format code:

```bash
dart format .
```

---

## 📦 Build

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

---

## 📸 Screenshots (add yours)

Create a folder and drop images:

```text
assets/screenshots/
  home.png
  product.png
  cart.png
  checkout.png
```

Then update this section:

| Home | Product | Cart | Checkout |
|------|---------|------|----------|
| ![](assets/screenshots/home.png) | ![](assets/screenshots/product.png) | ![](assets/screenshots/cart.png) | ![](assets/screenshots/checkout.png) |

---

## 🗺️ Roadmap

- [ ] API integration + caching
- [ ] Auth (JWT) + refresh token flow
- [ ] Checkout: address + payment integration
- [ ] Offline mode (local DB)
- [ ] CI (GitHub Actions): analyze + test + build

---

## 🤝 Contributing

1. Fork the repository  
2. Create a feature branch: `git checkout -b feat/my-feature`  
3. Commit changes: `git commit -m "feat: add my feature"`  
4. Open a Pull Request  

---

## 📄 License

This project is licensed under the terms of the repository’s `LICENSE` file (if present).

---

## 👤 Author

**Pouria Shirali**  
- GitHub: https://github.com/pouriashiralipour  
- LinkedIn: https://linkedin.com/in/pouriashiralipour  
- Instagram: https://instagram.com/pouria.shirali
