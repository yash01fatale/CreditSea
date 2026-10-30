import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/loan_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/otp_view.dart';
import '../../views/home/bottom_nav_view.dart';
import '../../views/loan/loan_application_view.dart';
import '../../views/loan/loan_detail_view.dart';
import '../../views/profile/profile_setup_view.dart';
import '../../views/splash/splash_view.dart';
import '../../views/welcome/welcome_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static void _register<T>(T Function() builder) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(builder, fenix: true);
    }
  }

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => OtpView(),
    ),
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => ProfileSetupView(),
      binding: BindingsBuilder(() {
        _register<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const BottomNavView(),
      binding: BindingsBuilder(() {
        _register<HomeController>(() => HomeController());
        _register<LoanController>(() => LoanController());
        _register<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.loanCalculator,
      page: () => const BottomNavView(initialIndex: 1),
      binding: BindingsBuilder(() {
        _register<HomeController>(() => HomeController());
        _register<LoanController>(() => LoanController());
        _register<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.loanStatus,
      page: () => const BottomNavView(initialIndex: 2),
      binding: BindingsBuilder(() {
        _register<HomeController>(() => HomeController());
        _register<LoanController>(() => LoanController());
        _register<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const BottomNavView(initialIndex: 3),
      binding: BindingsBuilder(() {
        _register<HomeController>(() => HomeController());
        _register<LoanController>(() => LoanController());
        _register<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.loanApplication,
      page: () => LoanApplicationView(),
      binding: BindingsBuilder(() {
        _register<LoanController>(() => LoanController());
      }),
    ),
    GetPage(
      name: AppRoutes.loanDetail,
      page: () => const LoanDetailView(),
      binding: BindingsBuilder(() {
        _register<LoanController>(() => LoanController());
      }),
    ),
  ];
}
