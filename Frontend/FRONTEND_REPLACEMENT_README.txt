CREDITSEA FLUTTER FRONTEND REPLACEMENT

This frontend was rebuilt as native Flutter widgets from the 10 supplied Stitch AI HTML screens.

FULL PROJECT:
- Extract CreditSea_Stitch_Integrated_Project.zip.
- Open creditsea/creditsea_app in VS Code.
- Run: flutter pub get
- Run: flutter analyze
- Run: flutter run -d chrome

FRONTEND-ONLY PATCH:
- Extract CreditSea_Flutter_Frontend_Only.zip directly into your existing creditsea_app folder.
- Allow it to replace the existing lib folder.
- No additional pubspec dependencies were added; existing GetX, google_fonts, intl and Flutter packages are used.
- Then run: flutter pub get
- Then run: flutter analyze
- Then run: flutter run -d chrome

BACKEND:
- Start MongoDB.
- Create backend/.env from backend/.env.example.
- Set MONGO_URI and JWT_SECRET.
- Run npm install and npm run dev from backend.
- OTP is mocked and printed in the backend terminal.

IMPORTANT:
- CreditSea score is illustrative, not an official CIBIL score.
- Actual SMS, credit bureau, UIDAI/Aadhaar, bank verification, e-NACH, payment processing, repayment history and push notification integrations are not configured.
- The frontend only displays live values provided by the current backend APIs.
