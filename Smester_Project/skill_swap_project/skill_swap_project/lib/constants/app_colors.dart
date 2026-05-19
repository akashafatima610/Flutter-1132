import 'package:flutter/material.dart';

class AppColors {
  // Primary (Professional Navy Blue)
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color primaryDark = Color(0xFF1E293B);

  // Secondary (Elegant Gold)
  static const Color secondary = Color(0xFFD4AF37);
  static const Color secondaryLight = Color(0xFFFEF7CD);
  static const Color secondaryDark = Color(0xFFB45309);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color star = Color(0xFFFBBF24);

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  );

  // Chat
  static const Color bubbleSent = Color(0xFF1E3A8A);
  static const Color bubbleReceived = Color(0xFFF1F5F9);
  static const Color bubbleSentText = Color(0xFFFFFFFF);
  static const Color bubbleReceivedText = Color(0xFF0F172A);
}