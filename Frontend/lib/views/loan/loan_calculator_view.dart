import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/loan_controller.dart';
import '../../widgets/creditsea_ui.dart';

class LoanCalculatorView extends StatelessWidget {
  LoanCalculatorView({super.key});

  final LoanController c = Get.find<LoanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('EMI calculator'),
        backgroundColor: CreditSeaColors.background,
        actions: [
          IconButton(
            onPressed: () => Get.snackbar(
              'EMI calculator',
              'This is an indicative estimate. Final rates are set by the lending partner.',
            ),
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Text(
              'FINANCIAL SIMULATOR',
              style: TextStyle(
                color: CreditSeaColors.blue,
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Plan your repayments.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Adjust the amount and tenure to see an estimated monthly instalment.',
              style: TextStyle(
                color: CreditSeaColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            CreditSeaCard(
              color: CreditSeaColors.navyCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR ESTIMATED EMI',
                    style: TextStyle(
                      color: Color(0xFFC6D5E4),
                      fontSize: 10,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${inr(c.emi.value)} / month',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _darkMetric(
                          'Interest rate',
                          '${c.interestRate.value.toStringAsFixed(1)}% p.a.',
                        ),
                      ),
                      Expanded(
                        child: _darkMetric(
                          'Total payable',
                          inr(c.totalPayable.value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CreditSeaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Loan amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: CreditSeaColors.text,
                          ),
                        ),
                      ),
                      Text(
                        inr(c.loanAmount.value),
                        style: TextStyle(
                          color: CreditSeaColors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: c.loanAmount.value.clamp(10000, 1000000).toDouble(),
                    min: 10000,
                    max: 1000000,
                    divisions: 99,
                    activeColor: CreditSeaColors.blue,
                    onChanged: (value) {
                      c.loanAmount.value = value.roundToDouble();
                      c.calculateEMI();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹10,000',
                          style: TextStyle(
                              color: CreditSeaColors.muted, fontSize: 10)),
                      Text('₹10,00,000',
                          style: TextStyle(
                              color: CreditSeaColors.muted, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 21),
                  Text(
                    'Quick select',
                    style: TextStyle(
                      color: CreditSeaColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [50000, 100000, 200000, 300000, 500000]
                        .map(
                          (amount) => ChoiceChip(
                            label: Text(
                              amount >= 100000
                                  ? '₹${(amount / 100000).toStringAsFixed(amount % 100000 == 0 ? 0 : 1)}L'
                                  : inr(amount),
                            ),
                            selected: c.loanAmount.value == amount.toDouble(),
                            onSelected: (_) {
                              c.loanAmount.value = amount.toDouble();
                              c.calculateEMI();
                            },
                            selectedColor: CreditSeaColors.blueSoft,
                            labelStyle: TextStyle(
                              color: c.loanAmount.value == amount.toDouble()
                                  ? CreditSeaColors.blue
                                  : CreditSeaColors.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                            side: BorderSide(
                              color: c.loanAmount.value == amount.toDouble()
                                  ? CreditSeaColors.blue
                                  : CreditSeaColors.line,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Repayment tenure',
                          style: TextStyle(
                            color: CreditSeaColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${c.tenure.value} months',
                        style: TextStyle(
                          color: CreditSeaColors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: c.tenure.value.toDouble().clamp(3, 60).toDouble(),
                    min: 3,
                    max: 60,
                    divisions: 57,
                    activeColor: CreditSeaColors.blue,
                    onChanged: (value) {
                      c.tenure.value = value.round();
                      c.calculateEMI();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('3 months',
                          style: TextStyle(
                              color: CreditSeaColors.muted, fontSize: 10)),
                      Text('60 months',
                          style: TextStyle(
                              color: CreditSeaColors.muted, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [6, 12, 24, 36, 48, 60]
                        .map(
                          (months) => ChoiceChip(
                            label: Text('$months M'),
                            selected: c.tenure.value == months,
                            onSelected: (_) {
                              c.tenure.value = months;
                              c.calculateEMI();
                            },
                            selectedColor: CreditSeaColors.blueSoft,
                            labelStyle: TextStyle(
                              color: c.tenure.value == months
                                  ? CreditSeaColors.blue
                                  : CreditSeaColors.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            CreditSeaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repayment breakdown',
                    style: TextStyle(
                      color: CreditSeaColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: _breakdownLegend(
                          CreditSeaColors.blue,
                          'Principal',
                          inr(c.loanAmount.value),
                        ),
                      ),
                      Expanded(
                        child: _breakdownLegend(
                          CreditSeaColors.mint,
                          'Interest',
                          inr(c.totalInterest.value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: c.totalPayable.value <= 0
                          ? 0
                          : (c.loanAmount.value / c.totalPayable.value)
                              .clamp(0.0, 1.0).toDouble(),
                      minHeight: 9,
                      backgroundColor: CreditSeaColors.mint,
                      valueColor: AlwaysStoppedAnimation(
                        CreditSeaColors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  CreditSeaLabelValue(
                    label: 'Principal amount',
                    value: inr(c.loanAmount.value),
                  ),
                  CreditSeaLabelValue(
                    label: 'Total interest',
                    value: inr(c.totalInterest.value),
                  ),
                  const Divider(height: 18),
                  CreditSeaLabelValue(
                    label: 'Total repayment',
                    value: inr(c.totalPayable.value),
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CreditSeaPrimaryButton(
              label: 'Continue to application',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Get.toNamed(AppRoutes.loanApplication),
            ),
            const SizedBox(height: 12),
            Text(
              'Illustrative estimate calculated at the displayed annual interest rate. Actual terms, fees and approval are subject to the lending partner.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CreditSeaColors.muted,
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _darkMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFFB8C9DA), fontSize: 10)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _breakdownLegend(Color color, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.only(top: 3, right: 7),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: CreditSeaColors.muted, fontSize: 10)),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: CreditSeaColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
