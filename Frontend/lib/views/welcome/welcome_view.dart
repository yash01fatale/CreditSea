import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/theme_toggle_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [CreditSeaBrand(), Spacer(), CreditSeaThemeButton()],
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: CreditSeaColors.navyCard,
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CreditSeaColors.navyDeep,
                      CreditSeaColors.navyCard,
                      Color(0xFF174B79),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: CreditSeaColors.mint.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'NEXT-GEN LENDING EXPERIENCE',
                        style: TextStyle(
                          color: CreditSeaColors.mint,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Smart borrowing.\\nBetter decisions.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A simpler way to plan your next financial step with transparent loan estimates and digital application tracking.',
                      style: TextStyle(
                        color: Color(0xFFD1DEEB),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const _FeatureRow(
                      icon: Icons.bolt_rounded,
                      title: 'Simple digital application',
                      subtitle: 'Apply with a few guided steps',
                    ),
                    const SizedBox(height: 16),
                    const _FeatureRow(
                      icon: Icons.calculate_outlined,
                      title: 'Clear EMI estimates',
                      subtitle: 'Understand repayment before applying',
                    ),
                    const SizedBox(height: 16),
                    const _FeatureRow(
                      icon: Icons.track_changes_rounded,
                      title: 'Application tracking',
                      subtitle: 'Follow every available status update',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CreditSeaPrimaryButton(
                label: 'Get started',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Get.toNamed(AppRoutes.login),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: CreditSeaColors.muted,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: CreditSeaColors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Secure assignment demo • Loan approval is subject to lender assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CreditSeaColors.muted,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: CreditSeaColors.mint, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFC6D5E4),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: CreditSeaColors.mint,
          size: 17,
        ),
      ],
    );
  }
}
