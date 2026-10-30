import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/loan_model.dart';
import '../services/loan_service.dart';

class LoanController extends GetxController {
  final LoanService _loanService = LoanService();

  // Calculator observables
  final loanAmount = 100000.0.obs;
  final tenure = 12.obs;
  final interestRate = 12.0.obs;
  final emi = 0.0.obs;
  final totalPayable = 0.0.obs;
  final totalInterest = 0.0.obs;

  // Loan list & detail
  final loans = <LoanModel>[].obs;
  final selectedLoan = Rxn<LoanModel>();
  final isLoading = false.obs;
  final creditScore = 0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateEMI();
    fetchLoans();
  }

  // ── EMI Calculation (local, instant) ───────────────────────────────────

  void calculateEMI() {
    final p = loanAmount.value;
    final n = tenure.value;
    final r = interestRate.value / 12 / 100; // monthly rate

    if (r == 0) {
      emi.value = p / n;
    } else {
      final factor = pow(1 + r, n);
      emi.value = (p * r * factor) / (factor - 1);
    }
    totalPayable.value = emi.value * n;
    totalInterest.value = totalPayable.value - p;
  }

  /// Also hit the backend for server-side calculation (optional sync).
  Future<void> calculateEMIRemote() async {
    try {
      final response = await _loanService.calculateEMI(
        loanAmount.value,
        tenure.value,
      );
      final data = response['data'] ?? response;
      emi.value = (data['emi'] ?? emi.value).toDouble();
      totalPayable.value = (data['totalPayable'] ?? totalPayable.value).toDouble();
      totalInterest.value = totalPayable.value - loanAmount.value;
    } catch (_) {
      // Fallback: local calculation is already done.
    }
  }

  // ── Apply ──────────────────────────────────────────────────────────────

  Future<bool> applyLoan(String purpose) async {
    isLoading.value = true;
    try {
      final response = await _loanService.applyLoan(
        amount: loanAmount.value,
        tenure: tenure.value,
        purpose: purpose,
      );
      Get.snackbar(
        'Application Submitted',
        response['message'] ?? 'Your loan application has been submitted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 3),
      );
      await fetchLoans();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch ──────────────────────────────────────────────────────────────

  Future<void> fetchLoans() async {
    isLoading.value = true;
    try {
      final response = await _loanService.getLoans();
      final payload = response['data'] ?? response;
      final list = payload is Map ? (payload['loans'] ?? []) : payload;
      loans.value = (list as List)
          .map((e) => LoanModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      // Keep existing list on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLoanDetail(String id) async {
    selectedLoan.value = null;
    isLoading.value = true;
    try {
      final response = await _loanService.getLoanById(id);
      final data = response['data'] ?? response;
      selectedLoan.value = LoanModel.fromJson(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCreditScore() async {
    try {
      final response = await _loanService.getCreditScore();
      creditScore.value =
          response['creditScore'] ?? response['data']?['creditScore'] ?? 0;
    } catch (_) {}
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  int get activeLoansCount =>
      loans.where((l) =>
          l.status?.toLowerCase() != 'rejected' &&
          l.status?.toLowerCase() != 'disbursed').length;

  double get totalLoanAmount =>
      loans.fold(0.0, (sum, l) => sum + l.amount);
}
