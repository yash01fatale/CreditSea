import 'package:flutter/material.dart';

import '../../widgets/creditsea_ui.dart';
import '../loan/loan_calculator_view.dart';
import '../loan/loan_status_view.dart';
import '../profile/profile_view.dart';
import 'home_view.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late int index;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex.clamp(0, 3).toInt();
    pages = [
      HomeView(onOpenTab: (value) => setState(() => index = value)),
      LoanCalculatorView(),
      const LoanStatusView(),
      ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate_rounded),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Loans',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
