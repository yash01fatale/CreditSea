# CreditSea Flutter App

Flutter frontend for the CreditSea loan application demo.

## Run
```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

The app uses GetX for routing and state management. Backend API defaults to `http://localhost:5000/api` on Chrome and `http://10.0.2.2:5000/api` on the Android emulator.

Override the API URL with:
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000/api
```

OTP is mocked by the backend and printed in its terminal. Real SMS, credit bureau, bank mandate, and EMI payment integrations are not configured.
