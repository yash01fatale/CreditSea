# CreditSea – Flutter + Node.js + MongoDB

CreditSea is a Flutter loan application demo with a Node.js/Express backend and MongoDB persistence.

## Flutter UI

The Flutter UI has been redesigned from the supplied Stitch AI screens using native Flutter widgets and GetX state management.

### Screens
1. Welcome landing
2. Mobile login
3. OTP verification
4. KYC/profile setup
5. Home dashboard
6. Loan EMI calculator
7. Loan application
8. Application tracking
9. Loan details and status timeline
10. User profile

### Design system
- Navy: `#102A43`
- Blue: `#226AFC`
- Mint: `#20C997`
- Background: `#F6F8FC`
- Typography: Inter + Manrope
- Four-tab navigation: Home, Calculator, Loans, Profile
- Light and dark themes, with the selected mode saved between launches
- Back navigation on pushed flows and route-aware app bars

### Flutter setup
```bash
cd creditsea_app
flutter pub get
flutter analyze
flutter run -d chrome
```

For Chrome, the API defaults to `http://localhost:5000/api`. To override:
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000/api
```

For Android emulator, the API service uses `http://10.0.2.2:5000/api` by default.

## Backend setup
```bash
cd backend
npm install
```

Create `backend/.env` from `.env.example` and set:
```env
PORT=5000
MONGO_URI=mongodb://127.0.0.1:27017/creditsea
JWT_SECRET=replace_with_a_long_random_secret
JWT_EXPIRE=30d
ADMIN_API_KEY=replace_with_a_long_random_admin_key
```

Start the backend:
```bash
npm run dev
```

The demo OTP is printed in the backend terminal. SMS delivery is not configured.

## Theme and navigation
- The app follows the device theme by default. Use the sun/moon button in the welcome, login, OTP, home or profile header to switch between light and dark mode. The selected choice is persisted locally.
- Back buttons are available on login, OTP and profile setup; loan application and detail pages use the standard app-bar back navigation.

## Important demo limitations
- Credit score is an illustrative app score, not an official CIBIL score.
- Eligibility is a basic demo rule and is not a lending decision.
- Bank account verification, e-NACH, Aadhaar/UIDAI, credit bureau checks, push notifications and actual EMI payments are not integrated.
- Loan status changes require the backend's admin status endpoint.
- The app does not guarantee loan approval or disbursement.

## Stitch references
Original supplied Stitch HTML screens are retained in `design_reference/stitch_html/`. The Flutter app uses native Dart widgets; it does not embed Tailwind/HTML inside Flutter.

## API reference
All private endpoints below require `Authorization: Bearer <JWT>` except OTP routes.

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/api/auth/send-otp` | Generate a demo OTP (printed in backend terminal) |
| POST | `/api/auth/verify-otp` | Verify OTP and return JWT / register or login |
| GET | `/api/profile` | Read the signed-in user's profile |
| PUT | `/api/profile` | Update profile details |
| POST | `/api/loan/calculate` | Calculate EMI |
| POST | `/api/loan/apply` | Submit a loan application |
| GET | `/api/loan/applications` | List signed-in user's applications |
| GET | `/api/loan/:id` | Read one application |
| GET | `/api/loan/credit-score` | Read the demo score |
| PUT | `/api/loan/:id/status` | Admin/demo status update; requires both JWT and `x-admin-key` |

### Update an application status (demo/admin)
Use the authenticated user's JWT and the backend-only `ADMIN_API_KEY`. Never place the admin key in Flutter code or a mobile build.

```bash
curl -X PUT http://localhost:5000/api/loan/LOAN_ID/status \
  -H "Authorization: Bearer USER_JWT" \
  -H "x-admin-key: YOUR_ADMIN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"status":"Under Review","note":"Documents are being reviewed"}'
```
Allowed statuses: `Submitted`, `Under Review`, `Approved`, `Rejected`, `Disbursed`.

## Android build
From `creditsea_app`:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`.

For a physical Android phone on the same Wi-Fi network, pass your development PC's LAN IP:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5000/api
```

Replace `192.168.1.10` with your PC's actual LAN IP. Android emulator uses `10.0.2.2` automatically. For production, deploy the API over HTTPS and configure the HTTPS URL with `--dart-define=API_BASE_URL=...`.

## Final pre-submission checks
- Run `flutter analyze` and `flutter test` on the machine with the Flutter SDK.
- Run the backend against a local MongoDB instance and test the API flows.
- Test both light and dark modes, including a cold app restart.
- Test Android release APK on a physical device, not only Chrome/debug mode.
- Confirm no `.env`, secrets, or admin key are committed to GitHub.
- Record a 5–10 minute demo and upload APK/video links before emailing HR.
