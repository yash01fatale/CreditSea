import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/loan_controller.dart';
import '../../models/loan_model.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/status_timeline.dart';

class LoanDetailView extends StatefulWidget {
  const LoanDetailView({super.key});

  @override
  State<LoanDetailView> createState() => _LoanDetailViewState();
}

class _LoanDetailViewState extends State<LoanDetailView> {
  final LoanController c = Get.find<LoanController>();

  @override
  void initState() {
    super.initState();
    final argument = Get.arguments;
    if (argument is String && argument.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.fetchLoanDetail(argument);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('Loan details'),
        backgroundColor: CreditSeaColors.background,
      ),
      body: Obx(() {
        if (c.isLoading.value && c.selectedLoan.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final loan = c.selectedLoan.value;
        if (loan == null) {
          return const Center(
            child: Text('Application details are unavailable.'),
          );
        }
        return _details(context, loan);
      }),
    );
  }

  Widget _details(BuildContext context, LoanModel loan) {
    final applied = loan.appliedAt == null
        ? 'Not available'
        : DateFormat('dd MMM yyyy, hh:mm a').format(loan.appliedAt!);

    final reference = loan.id == null
        ? 'Not available'
        : loan.id!.toUpperCase();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        CreditSeaCard(
          color: CreditSeaColors.navyCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'APPLICATION REFERENCE',
                style: TextStyle(
                  color: Color(0xFFC6D5E4),
                  fontSize: 9,
                  letterSpacing: .9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                reference.length > 16
                    ? 'CS-${reference.substring(reference.length - 10)}'
                    : reference,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                inr(loan.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${loan.purpose ?? 'Personal'} loan request',
                style: const TextStyle(
                  color: Color(0xFFC6D5E4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              CreditSeaStatusPill(loan.displayStatus),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const CreditSeaSectionTitle('Loan summary'),
        const SizedBox(height: 10),
        CreditSeaCard(
          child: Column(
            children: [
              CreditSeaLabelValue(
                label: 'Requested amount',
                value: inr(loan.amount),
              ),
              CreditSeaLabelValue(
                label: 'Monthly EMI estimate',
                value: inr(loan.emi),
              ),
              CreditSeaLabelValue(
                label: 'Annual interest rate',
                value: '${loan.interestRate.toStringAsFixed(2)}% p.a.',
              ),
              CreditSeaLabelValue(
                label: 'Repayment tenure',
                value: '${loan.tenure} months',
              ),
              CreditSeaLabelValue(
                label: 'Total repayment estimate',
                value: inr(loan.totalPayable),
                bold: true,
              ),
              CreditSeaLabelValue(
                label: 'Application submitted',
                value: applied,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const CreditSeaSectionTitle('Application timeline'),
        const SizedBox(height: 12),
        CreditSeaCard(
          child: StatusTimeline(
            history: loan.statusHistory,
            currentStatus: loan.status ?? 'Submitted',
          ),
        ),
        if (loan.rejectionReason != null &&
            loan.rejectionReason!.isNotEmpty) ...[
          const SizedBox(height: 16),
          CreditSeaCard(
            color: CreditSeaColors.dangerSoft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: CreditSeaColors.danger),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Application update\\n${loan.rejectionReason}',
                    style: TextStyle(
                      color: CreditSeaColors.danger,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        CreditSeaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      color: CreditSeaColors.blue, size: 20),
                  SizedBox(width: 9),
                  Text(
                    'Repayment overview',
                    style: TextStyle(
                      color: CreditSeaColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                'Your estimated EMI is ${inr(loan.emi)} for ${loan.tenure} months. Actual repayment dates and payment history will be shown when repayment services are connected.',
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 11,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
