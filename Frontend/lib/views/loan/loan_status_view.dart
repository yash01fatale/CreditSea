import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/loan_controller.dart';
import '../../models/loan_model.dart';
import '../../widgets/creditsea_ui.dart';

class LoanStatusView extends StatefulWidget {
  const LoanStatusView({super.key});

  @override
  State<LoanStatusView> createState() => _LoanStatusViewState();
}

class _LoanStatusViewState extends State<LoanStatusView> {
  final LoanController c = Get.find<LoanController>();
  String filter = 'All';

  final filters = const [
    'All',
    'Submitted',
    'Under Review',
    'Approved',
    'Rejected',
    'Disbursed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('My applications'),
        backgroundColor: CreditSeaColors.background,
        actions: [
          IconButton(
            onPressed: c.fetchLoans,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        final filtered = c.loans.where((loan) {
          if (filter == 'All') return true;
          return loan.displayStatus.toLowerCase() == filter.toLowerCase();
        }).toList();

        return RefreshIndicator(
          onRefresh: c.fetchLoans,
          color: CreditSeaColors.blue,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Text(
                'Stay on top of every update.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'View your submitted loan requests and their latest status.',
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      'Total applications',
                      '${c.loans.length}',
                      Icons.description_outlined,
                      CreditSeaColors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _summaryCard(
                      'In progress',
                      '${c.activeLoansCount}',
                      Icons.pending_actions_rounded,
                      const Color(0xFFB76A00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'FILTER BY STATUS',
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 7),
                  itemBuilder: (context, index) {
                    final item = filters[index];
                    final selected = filter == item;
                    return ChoiceChip(
                      label: Text(item),
                      selected: selected,
                      onSelected: (_) => setState(() => filter = item),
                      selectedColor: CreditSeaColors.blue,
                      backgroundColor: CreditSeaColors.surface,
                      side: BorderSide(
                        color: selected
                            ? CreditSeaColors.blue
                            : CreditSeaColors.line,
                      ),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : CreditSeaColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 17),
              if (c.isLoading.value && c.loans.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(35),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filtered.isEmpty)
                _emptyState()
              else
                ...filtered.map(
                  (loan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _applicationCard(loan),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Application status is updated by the backend demo workflow. Approval and disbursement are not guaranteed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _summaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return CreditSeaCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: CreditSeaColors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: CreditSeaColors.muted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _applicationCard(LoanModel loan) {
    final date = loan.appliedAt == null
        ? 'Date not available'
        : DateFormat('dd MMM yyyy').format(loan.appliedAt!);

    return InkWell(
      onTap: loan.id == null
          ? null
          : () => Get.toNamed(AppRoutes.loanDetail, arguments: loan.id),
      borderRadius: BorderRadius.circular(19),
      child: CreditSeaCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CreditSeaColors.blueSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: CreditSeaColors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${loan.purpose ?? 'Personal'} loan',
                        style: TextStyle(
                          color: CreditSeaColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Applied on $date',
                        style: TextStyle(
                          color: CreditSeaColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                CreditSeaStatusPill(loan.displayStatus),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: _detail('Requested amount', inr(loan.amount)),
                ),
                Expanded(
                  child: _detail('Tenure', '${loan.tenure} months'),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: CreditSeaColors.muted),
              ],
            ),
            if (loan.rejectionReason != null &&
                loan.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CreditSeaColors.dangerSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'Reason: ${loan.rejectionReason}',
                  style: TextStyle(
                    color: CreditSeaColors.danger,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: CreditSeaColors.muted, fontSize: 9)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: CreditSeaColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return CreditSeaCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined,
              color: CreditSeaColors.blue, size: 38),
          const SizedBox(height: 12),
          Text(
            'No applications found',
            style: TextStyle(
              color: CreditSeaColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            filter == 'All'
                ? 'Your applications will appear here once submitted.'
                : 'There are no applications with this status.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CreditSeaColors.muted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
