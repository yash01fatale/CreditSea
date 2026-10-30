import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/creditsea_ui.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late final Animation<double> _fade;
  bool _routed = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _animation, curve: Curves.easeOut);
    _animation.forward();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted || _routed) return;
      _routed = true;
      Get.find<AuthController>().checkAuth();
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.navyDeep,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CreditSeaColors.navyDeep,
              CreditSeaColors.navyCard,
              Color(0xFF164A79),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(27),
                  boxShadow: [
                    BoxShadow(
                      color: CreditSeaColors.blue.withValues(alpha: .35),
                      blurRadius: 35,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.waves_rounded,
                  color: CreditSeaColors.blue,
                  size: 48,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'CreditSea',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Smart borrowing. Better financial decisions.',
                style: TextStyle(
                  color: Color(0xFFD7E5F5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 58),
              SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: CreditSeaColors.mint,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SECURE • SIMPLE • TRANSPARENT',
                style: TextStyle(
                  color: Color(0xFFB5CBE1),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
