import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

class CreditSeaColors {
  CreditSeaColors._();

  static bool get dark => Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>().isDark
      : Get.isDarkMode;
  static Color get navy => dark ? const Color(0xFFE5EEF9) : const Color(0xFF102A43);
  static const navyCard = Color(0xFF102A43);
  static const navyDeep = Color(0xFF00152A);
  static const blue = Color(0xFF226AFC);
  static Color get blueSoft => dark ? const Color(0xFF1B3152) : const Color(0xFFEAF0FF);
  static const mint = Color(0xFF20C997);
  static Color get mintSoft => dark ? const Color(0xFF153B35) : const Color(0xFFE4FBF3);
  static Color get background => dark ? const Color(0xFF0B1220) : const Color(0xFFF6F8FC);
  static Color get surface => dark ? const Color(0xFF151F2E) : Colors.white;
  static Color get text => dark ? const Color(0xFFE8EEF7) : const Color(0xFF172B4D);
  static Color get muted => dark ? const Color(0xFFA5B4C7) : const Color(0xFF718096);
  static Color get line => dark ? const Color(0xFF2B3B50) : const Color(0xFFE7ECF3);
  static const warning = Color(0xFFF4A340);
  static Color get warningSoft => dark ? const Color(0xFF46351C) : const Color(0xFFFFF5E7);
  static const danger = Color(0xFFE05252);
  static Color get dangerSoft => dark ? const Color(0xFF48232B) : const Color(0xFFFFEEEE);
}

String inr(num value, {bool decimals = false}) {
  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: decimals ? 2 : 0,
  ).format(value);
}

class CreditSeaCard extends StatelessWidget {
  const CreditSeaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.radius = 20,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? CreditSeaColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: CreditSeaColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0800152A),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CreditSeaPrimaryButton extends StatelessWidget {
  const CreditSeaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: CreditSeaColors.blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: CreditSeaColors.blue.withValues(alpha: .45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label),
                  if (icon != null) ...[
                    const SizedBox(width: 10),
                    Icon(icon, size: 19),
                  ],
                ],
              ),
      ),
    );
  }
}

class CreditSeaOutlineButton extends StatelessWidget {
  const CreditSeaOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: CreditSeaColors.navy,
          side: BorderSide(color: CreditSeaColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class CreditSeaSectionTitle extends StatelessWidget {
  const CreditSeaSectionTitle(
    this.title, {
    super.key,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: CreditSeaColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -.25,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: TextStyle(
                color: CreditSeaColors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class CreditSeaStatusPill extends StatelessWidget {
  const CreditSeaStatusPill(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final key = status.toLowerCase().replaceAll('_', ' ');
    final Color color;
    final Color bg;
    if (key == 'approved' || key == 'disbursed') {
      color = const Color(0xFF16845D);
      bg = CreditSeaColors.mintSoft;
    } else if (key == 'rejected') {
      color = CreditSeaColors.danger;
      bg = CreditSeaColors.dangerSoft;
    } else if (key == 'under review') {
      color = const Color(0xFFB76A00);
      bg = CreditSeaColors.warningSoft;
    } else {
      color = CreditSeaColors.blue;
      bg = CreditSeaColors.blueSoft;
    }

    final label = key
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class CreditSeaLabelValue extends StatelessWidget {
  const CreditSeaLabelValue({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: CreditSeaColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor ?? CreditSeaColors.text,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CreditSeaBrand extends StatelessWidget {
  const CreditSeaBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 36 : 44,
          height: compact ? 36 : 44,
          decoration: BoxDecoration(
            color: CreditSeaColors.blue,
            borderRadius: BorderRadius.circular(compact ? 11 : 14),
          ),
          child: Icon(
            Icons.waves_rounded,
            color: Colors.white,
            size: compact ? 21 : 26,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'CreditSea',
          style: TextStyle(
            color: CreditSeaColors.navy,
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -.8,
          ),
        ),
      ],
    );
  }
}

InputDecoration creditSeaInput({
  required String label,
  String? hint,
  Widget? prefix,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: CreditSeaColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: CreditSeaColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: CreditSeaColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: CreditSeaColors.blue, width: 1.5),
    ),
  );
}
