import 'package:flutter_test/flutter_test.dart';
import 'package:creditsea_app/controllers/loan_controller.dart';

void main() {
  test('EMI calculator returns a positive repayment amount', () {
    final controller = LoanController();
    controller.loanAmount.value = 100000;
    controller.tenure.value = 12;
    controller.interestRate.value = 12;
    controller.calculateEMI();
    expect(controller.emi.value, greaterThan(0));
    expect(controller.totalPayable.value, greaterThan(100000));
    expect(controller.totalInterest.value, greaterThan(0));
  });
}
