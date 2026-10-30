import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/theme_toggle_button.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final AuthController c = Get.find<AuthController>();

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
        actions: const [CreditSeaThemeButton()],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CreditSeaBrand(),
                    const SizedBox(height: 42),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: CreditSeaColors.blueSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: CreditSeaColors.blue,
                        size: 29,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Welcome to\\nCreditSea 👋',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.13,
                            letterSpacing: -1.1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your mobile number to access your loan account or explore your loan options.',
                      style: TextStyle(
                        color: CreditSeaColors.muted,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      'MOBILE NUMBER',
                      style: TextStyle(
                        color: CreditSeaColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: c.phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Enter 10-digit number',
                        prefixIcon: Container(
                          width: 72,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: CreditSeaColors.line),
                            ),
                          ),
                          child: Text(
                            '+91',
                            style: TextStyle(
                              color: CreditSeaColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
                        Icon(Icons.verified_user_outlined,
                            color: CreditSeaColors.mint, size: 17),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'A 6-digit verification code will be sent by SMS.',
                            style: TextStyle(
                              color: CreditSeaColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => CreditSeaPrimaryButton(
                        label: 'Get OTP',
                        icon: Icons.arrow_forward_rounded,
                        loading: c.isLoading.value,
                        onPressed: c.sendOTP,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'By proceeding, you agree to our ',
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: CreditSeaColors.blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                color: CreditSeaColors.blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CreditSeaColors.muted,
                          fontSize: 10,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Divider(color: CreditSeaColors.line),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline,
                            size: 15, color: CreditSeaColors.muted),
                        SizedBox(width: 7),
                        Text(
                          '256-bit encrypted • Secure sign in',
                          style: TextStyle(
                            color: CreditSeaColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
