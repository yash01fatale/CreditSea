import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/theme_toggle_button.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final AuthController c = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();
  Timer? _timer;
  int _seconds = 42;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 42;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  String get _countdown => '00:${_seconds.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        backgroundColor: CreditSeaColors.background,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const CreditSeaBrand(compact: true),
        actions: [
          const CreditSeaThemeButton(),
          IconButton(
            onPressed: () => Get.snackbar(
              'Secure verification',
              'Your OTP is used only to verify your mobile number.',
            ),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CreditSeaColors.mintSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF16845D),
                  size: 30,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Verify mobile\\nnumber',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We have sent a 6-digit verification code to',
                style: TextStyle(color: CreditSeaColors.muted, height: 1.5),
              ),
              const SizedBox(height: 5),
              Obx(
                () => Row(
                  children: [
                    Text(
                      '+91 ${c.phone.value}',
                      style: TextStyle(
                        color: CreditSeaColors.text,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'ENTER VERIFICATION CODE',
                style: TextStyle(
                  color: CreditSeaColors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                autofocus: true,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 15,
                  color: CreditSeaColors.text,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• • • • • •',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB8C3D1),
                    letterSpacing: 7,
                  ),
                  filled: true,
                  fillColor: CreditSeaColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: CreditSeaColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: CreditSeaColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: CreditSeaColors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: CreditSeaColors.muted,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _seconds > 0
                        ? 'Resend code in $_countdown'
                        : 'Didn’t get the code?',
                    style: TextStyle(
                      color: CreditSeaColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    final isLoading = c.isLoading.value;

                    return TextButton(
                      onPressed: _seconds > 0 || isLoading
                          ? null
                          : () async {
                              await c.resendOTP();
                              if (mounted) _startTimer();
                            },
                      child: const Text('Resend OTP'),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 22),
              Obx(
                () => CreditSeaPrimaryButton(
                  label: 'Verify & continue',
                  icon: Icons.arrow_forward_rounded,
                  loading: c.isLoading.value,
                  onPressed: () => c.verifyOTP(otpController.text),
                ),
              ),
              const SizedBox(height: 24),
              CreditSeaCard(
                color: CreditSeaColors.blueSoft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: CreditSeaColors.blue,
                      size: 21,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Security advisory\\nNever share your OTP with anyone. CreditSea will never ask for your verification code over a phone call.',
                        style: TextStyle(
                          color: CreditSeaColors.muted,
                          fontSize: 11,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Demo mode: OTP is printed in your backend terminal. SMS delivery is not configured.',
                  textAlign: TextAlign.center,
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
      ),
    );
  }
}
