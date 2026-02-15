import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const backGround = Color(0xFF0A0E1A); // Deep space black
  static const secondary = Color(0xFF1E2538); // Card background
  static const tertiary = Color(0xFF161B2D); // Darker card variant

  // Primary Green (Lime accent from dashboard)
  static const primary = Color(0xFFB8FF57); // Bright lime
  static const primaryDark = Color(0xFF8FD63F); // Darker lime

  // Tiers Colors
  static const tiersColors = [primary, yellow, orange, purple, pink, red];
  // Gradients
  static const primaryGradient = [
    Color(0xFF0A0E1A), // Background dark
    Color(0xFF161B2D), // Slightly lighter
  ];

  static const secondaryGradient = [
    Color(0xFFB8FF57), // Light lime
    Color(0xFF8FD63F), // Darker lime
  ];

  static final tertiaryGradient = [Color(0xFF1E2538), Color(0xFF161B2D)];

  static final quaternaryGradient = [
    primary.withOpacity(0.15),
    secondary.withOpacity(0.1),
  ];

  static final orangeGradient = [orange, orange.withOpacity(0.6)];

  // Accent Colors
  static const primaryFont = Colors.white;
  static const secondaryFont = Color(0xFF9CA3AF); // Grey text
  static const grey = Color(0xFF6B7280);
  static const border = Color(0xFF2D3548); // Card borders

  // Status Colors
  static const red = Color(0xFFFF6B6B); // Soft coral red
  static const yellow = Color(0xFFFFB84D); // Warning yellow
  static const green = Color(0xFF4ECDC4); // Teal accent
  static const blue = Color(0xFF6C63FF); // Purple-blue
  static const purple = Color(0xFF5B54E8); // Deep purple
  static const orange = Color(0xFFFF8A65); // Coral orange
  static const pink = Color(0xFFFF85C0); // Pink accent

  // Additional dashboard colors
  static const cardBg = Color(0xFF1E2538);
  static const inputBg = Color(0xFF0A0E1A);
  static const divider = Color(0xFF2D3548);
}
