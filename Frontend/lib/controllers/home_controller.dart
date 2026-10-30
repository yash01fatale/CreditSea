import 'package:get/get.dart';

import '../controllers/loan_controller.dart';
import '../controllers/profile_controller.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  final activeLoans = 0.obs;
  final totalAmount = 0.0.obs;
  final creditScore = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // Fetch profile data
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        await profileCtrl.fetchProfile();
        userName.value = profileCtrl.user.value.name ?? 'User';
        creditScore.value = profileCtrl.user.value.creditScore;
      }

      // Fetch loan data
      if (Get.isRegistered<LoanController>()) {
        final loanCtrl = Get.find<LoanController>();
        await loanCtrl.fetchLoans();
        await loanCtrl.getCreditScore();
        activeLoans.value = loanCtrl.activeLoansCount;
        totalAmount.value = loanCtrl.totalLoanAmount;
        if (loanCtrl.creditScore.value > 0) {
          creditScore.value = loanCtrl.creditScore.value;
        }
      }
    } catch (_) {
      // Dashboard errors are non-fatal
    } finally {
      isLoading.value = false;
    }
  }
}
