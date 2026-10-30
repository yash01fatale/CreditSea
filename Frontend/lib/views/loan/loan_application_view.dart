import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/loan_controller.dart';
import '../../widgets/creditsea_ui.dart';

class LoanApplicationView extends StatelessWidget {
  LoanApplicationView({super.key});

  final LoanController c = Get.find<LoanController>();
  final RxString purpose = 'Personal'.obs;
  final RxBool acceptedTerms = false.obs;

  static const _purposes = <_LoanPurpose>[
    _LoanPurpose('Personal', 'Personal expenses and planned purchases',
        Icons.person_outline_rounded),
    _LoanPurpose('Medical', 'Healthcare, treatment and medical bills',
        Icons.medical_services_outlined),
    _LoanPurpose('Home', 'Home repairs and furnishing',
        Icons.home_repair_service_outlined),
    _LoanPurpose('Education', 'Education and career development',
        Icons.school_outlined),
    _LoanPurpose('Business', 'Business and professional needs',
        Icons.storefront_outlined),
    _LoanPurpose('Other', 'Other eligible personal requirements',
        Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('Apply for a loan'),
        backgroundColor: CreditSeaColors.background,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _progressHeader(),
            const SizedBox(height: 22),
            Text(
              'Review your request',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Confirm your loan details and tell us how you plan to use the funds.',
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
                    'YOUR LOAN ESTIMATE',
                    style: TextStyle(
                      color: Color(0xFFC6D5E4),
                      fontSize: 10,
                      letterSpacing: .9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    inr(c.loanAmount.value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _summary('Tenure', '${c.tenure.value} months'),
                      ),
                      Expanded(
                        child: _summary('Estimated EMI', inr(c.emi.value)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const CreditSeaSectionTitle('Select loan purpose'),
            const SizedBox(height: 5),
            Text(
              'Choose the closest match for your application.',
              style: TextStyle(
                color: CreditSeaColors.muted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            ..._purposes.map((item) {
              final selected = purpose.value == item.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: InkWell(
                  onTap: () => purpose.value = item.value,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? CreditSeaColors.blueSoft
                          : CreditSeaColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? CreditSeaColors.blue
                            : CreditSeaColors.line,
                        width: selected ? 1.4 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: selected
                                ? CreditSeaColors.surface
                                : CreditSeaColors.background,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            item.icon,
                            color: selected
                                ? CreditSeaColors.blue
                                : CreditSeaColors.muted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.value == 'Personal'
                                    ? 'Personal expenses'
                                    : item.value,
                                style: TextStyle(
                                  color: CreditSeaColors.text,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.description,
                                style: TextStyle(
                                  color: CreditSeaColors.muted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          selected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: selected
                              ? CreditSeaColors.blue
                              : CreditSeaColors.muted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            CreditSeaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          color: CreditSeaColors.blue, size: 20),
                      SizedBox(width: 9),
                      Text(
                        'Loan estimate summary',
                        style: TextStyle(
                          color: CreditSeaColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CreditSeaLabelValue(
                    label: 'Indicative annual interest',
                    value: '${c.interestRate.value.toStringAsFixed(1)}% p.a.',
                  ),
                  CreditSeaLabelValue(
                    label: 'Estimated total interest',
                    value: inr(c.totalInterest.value),
                  ),
                  CreditSeaLabelValue(
                    label: 'Estimated total repayment',
                    value: inr(c.totalPayable.value),
                    bold: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The final interest rate, fees, eligibility and repayment terms will be disclosed by the lending partner before acceptance.',
                    style: TextStyle(
                      color: CreditSeaColors.muted,
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => acceptedTerms.toggle(),
              borderRadius: BorderRadius.circular(13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: acceptedTerms.value,
                    activeColor: CreditSeaColors.blue,
                    onChanged: (value) =>
                        acceptedTerms.value = value ?? false,
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 9),
                      child: Text(
                        'I confirm that the information provided is accurate and agree to the application terms and privacy policy.',
                        style: TextStyle(
                          color: CreditSeaColors.muted,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            CreditSeaPrimaryButton(
              label: 'Submit application',
              icon: Icons.arrow_forward_rounded,
              loading: c.isLoading.value,
              onPressed: () async {
                if (!acceptedTerms.value) {
                  Get.snackbar(
                    'Consent required',
                    'Please confirm the application terms to continue.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                final success = await c.applyLoan(purpose.value);
                if (success) {
                  Get.offAllNamed(AppRoutes.loanStatus);
                }
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Submitting an application does not guarantee approval or disbursement. This assignment uses a simulated lending workflow.',
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

  Widget _progressHeader() {
    return Row(
      children: [
        _progressStep('01', 'Amount', true),
        _progressLine(),
        _progressStep('02', 'Purpose', true),
        _progressLine(),
        _progressStep('03', 'Submit', false),
      ],
    );
  }

  Widget _progressStep(String number, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor:
              active ? CreditSeaColors.blue : const Color(0xFFE5EAF1),
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.white : CreditSeaColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: active ? CreditSeaColors.text : CreditSeaColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _progressLine() => Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.only(bottom: 17, left: 5, right: 5),
          color: CreditSeaColors.blue,
        ),
      );

  Widget _summary(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFFC6D5E4), fontSize: 10)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _LoanPurpose {
  const _LoanPurpose(this.value, this.description, this.icon);
  final String value;
  final String description;
  final IconData icon;
}
