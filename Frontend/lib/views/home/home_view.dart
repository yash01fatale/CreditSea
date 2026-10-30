import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/loan_controller.dart';
import '../../models/loan_model.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/theme_toggle_button.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key, this.onOpenTab});

  final ValueChanged<int>? onOpenTab;
  final HomeController home = Get.find<HomeController>();
  final LoanController loans = Get.find<LoanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await home.fetchDashboardData();
            await loans.fetchLoans();
          },
          color: CreditSeaColors.blue,
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                Row(
                  children: [
                    const CreditSeaBrand(compact: true),
                    const Spacer(),
                    const CreditSeaThemeButton(),
                    InkWell(
                      onTap: () => onOpenTab?.call(3),
                      borderRadius: BorderRadius.circular(30),
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: CreditSeaColors.blueSoft,
                        child: Text(
                          _initial(home.userName.value),
                          style: TextStyle(
                            color: CreditSeaColors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 27),
                Text(
                  'Good ${_greeting()},',
                  style: TextStyle(
                    color: CreditSeaColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  home.userName.value.isEmpty
                      ? 'Welcome back 👋'
                      : '${home.userName.value.split(' ').first} 👋',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 22),
                _creditHealthCard(home.creditScore.value),
                const SizedBox(height: 18),
                _loanOpportunityCard(context),
                const SizedBox(height: 23),
                const CreditSeaSectionTitle('Quick actions'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        icon: Icons.add_card_rounded,
                        title: 'Apply for loan',
                        subtitle: 'Start an application',
                        color: CreditSeaColors.blue,
                        onTap: () => onOpenTab?.call(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.calculate_rounded,
                        title: 'EMI calculator',
                        subtitle: 'Plan your instalments',
                        color: const Color(0xFF16845D),
                        onTap: () => onOpenTab?.call(1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _wideAction(
                  icon: Icons.track_changes_rounded,
                  title: 'Track your application',
                  subtitle: 'View the latest loan status and updates',
                  onTap: () => onOpenTab?.call(2),
                ),
                const SizedBox(height: 23),
                CreditSeaSectionTitle(
                  'Recent applications',
                  action: 'View all',
                  onAction: () => onOpenTab?.call(2),
                ),
                const SizedBox(height: 10),
                if (loans.isLoading.value && loans.loans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(25),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (loans.loans.isEmpty)
                  _emptyApplications(context)
                else
                  ...loans.loans.take(3).map(
                        (loan) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _recentLoanCard(loan),
                        ),
                      ),
                const SizedBox(height: 20),
                CreditSeaCard(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: CreditSeaColors.blue, size: 19),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your information is protected with secure authentication. Loan eligibility and terms are subject to lender assessment.',
                          style: TextStyle(
                            color: CreditSeaColors.muted,
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _creditHealthCard(int score) {
    final hasScore = score > 0;
    final normalized = hasScore ? ((score - 300) / 600).clamp(0.0, 1.0).toDouble() : 0.0;
    return CreditSeaCard(
      color: CreditSeaColors.navyCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'CREDIT HEALTH',
                  style: TextStyle(
                    color: Color(0xFFC5D6E8),
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: CreditSeaColors.mint.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'CreditSea demo score',
                  style: TextStyle(
                    color: CreditSeaColors.mint,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hasScore ? '$score' : '— — —',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 39,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'out of 900',
                  style: TextStyle(color: Color(0xFFB8C9DA), fontSize: 11),
                ),
              ),
              const Spacer(),
              Icon(
                hasScore ? Icons.trending_up_rounded : Icons.insights_rounded,
                color: CreditSeaColors.mint,
                size: 27,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: normalized,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: .15),
              valueColor:
                  AlwaysStoppedAnimation(CreditSeaColors.mint),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasScore
                ? 'Your current demo score is available in your profile.'
                : 'Your score will appear when available from the backend.',
            style: const TextStyle(
              color: Color(0xFFC5D6E8),
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanOpportunityCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF1FF), Color(0xFFF5F8FF)],
        ),
        border: Border.all(color: const Color(0xFFDDE7FF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PLAN YOUR NEXT STEP',
                  style: TextStyle(
                    color: CreditSeaColors.blue,
                    fontSize: 9,
                    letterSpacing: .9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A loan that fits\\nyour plans.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 19,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estimate your EMI before applying.',
                  style: TextStyle(
                    color: CreditSeaColors.muted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () => onOpenTab?.call(1),
                  child: Row(
                    children: [
                      Text(
                        'Explore loan options',
                        style: TextStyle(
                          color: CreditSeaColors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward_rounded,
                          size: 14, color: CreditSeaColors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .85),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: CreditSeaColors.blue,
              size: 43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: CreditSeaCard(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: TextStyle(
                color: CreditSeaColors.text,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: CreditSeaColors.muted,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wideAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: CreditSeaCard(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: CreditSeaColors.mintSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: const Color(0xFF16845D)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 12)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(
                          color: CreditSeaColors.muted, fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: CreditSeaColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _recentLoanCard(LoanModel loan) {
    return InkWell(
      onTap: loan.id == null
          ? null
          : () => Get.toNamed(AppRoutes.loanDetail, arguments: loan.id),
      borderRadius: BorderRadius.circular(17),
      child: CreditSeaCard(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CreditSeaColors.blueSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description_outlined,
                      color: CreditSeaColors.blue, size: 20),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.purpose ?? 'Personal loan',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        loan.id == null
                            ? 'Application'
                            : 'Ref. ${loan.id!.length > 8 ? loan.id!.substring(loan.id!.length - 8) : loan.id}',
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
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: _tinyMetric('Requested amount', inr(loan.amount)),
                ),
                Expanded(
                  child: _tinyMetric('Tenure', '${loan.tenure} months'),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 13, color: CreditSeaColors.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tinyMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: CreditSeaColors.muted, fontSize: 9)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: CreditSeaColors.text,
                fontWeight: FontWeight.w800,
                fontSize: 12)),
      ],
    );
  }

  Widget _emptyApplications(BuildContext context) {
    return CreditSeaCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: CreditSeaColors.blueSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_outlined,
                color: CreditSeaColors.blue, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            'No applications yet',
            style: TextStyle(
              color: CreditSeaColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Your loan applications will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CreditSeaColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () => onOpenTab?.call(1),
            child: const Text('Calculate your EMI'),
          ),
        ],
      ),
    );
  }

  String _initial(String value) =>
      value.trim().isEmpty ? 'C' : value.trim()[0].toUpperCase();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
