import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF102A43);
  static const secondary = Color(0xFF226AFC);
  static const accent = Color(0xFF20C997);
  static const error = Color(0xFFE05252);
  static const background = Color(0xFFF6F8FC);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF172B4D);
  static const textSecondary = Color(0xFF718096);

  static const submitted = Color(0xFF226AFC);
  static const underReview = Color(0xFFF4A340);
  static const approved = Color(0xFF16845D);
  static const rejected = Color(0xFFE05252);
  static const disbursed = Color(0xFF16845D);

  static Color statusColor(String status) {
    switch (status.toLowerCase().replaceAll('_', ' ')) {
      case 'submitted':
        return submitted;
      case 'under review':
        return underReview;
      case 'approved':
        return approved;
      case 'rejected':
        return rejected;
      case 'disbursed':
        return disbursed;
      default:
        return textSecondary;
    }
  }
}
