import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Using the vibrant blue from the image
  static const Color primary = Color(0xFF1976D2);        // Deep vibrant blue
  static const Color primaryLight = Color(0xFF42A5F5);   // Lighter blue
  static const Color primaryDark = Color(0xFF0A1653);    // Deeper blue
  
  // Secondary Colors
  static const Color secondary = Color(0xFF6C7B7F);      // Muted blue-gray
  static const Color secondaryLight = Color(0xFF9CADB2); // Light gray-blue
  static const Color secondaryDark = Color(0xFF4A5759);  // Dark gray-blue
  
  // Background Colors - Light Theme
  static const Color background = Color(0xFFFAFBFC);     // Very light gray
  static const Color surface = Color(0xFFFFFFFF);        // Pure white
  static const Color surfaceVariant = Color(0xFFF5F7FA); // Light gray
  
  // Text Colors - Light Theme
  static const Color textPrimary = Color(0xFF1A1D1F);    // Almost black
  static const Color textSecondary = Color(0xFF6B7280);  // Medium gray
  static const Color textTertiary = Color(0xFF9CA3AF);   // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // White
  
  // Attendance Specific Colors
  static const Color present = Color(0xFF10B981);        // Soft green
  static const Color absent = Color(0xFFEF4444);         // Soft red
  static const Color late = Color(0xFFF59E0B);           // Soft amber
  static const Color excused = Color(0xFF8B5CF6);        // Soft purple
  
  // Status Colors (Muted versions)
  static const Color success = Color(0xFF059669);        // Muted green
  static const Color warning = Color(0xFFD97706);        // Muted orange
  static const Color error = Color(0xFFDC2626);          // Muted red
  static const Color info = Color(0xFF1976D2);           // Using main blue
  
  // Neutral Colors - Light Theme
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);
  
  // Card and Component Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0A000000);     // Very subtle shadow
  static const Color divider = Color(0xFFE5E7EB);
  
  // Interactive Colors
  static const Color buttonPrimary = Color(0xFF1976D2);  // Using main blue
  static const Color buttonSecondary = Color(0xFFF3F4F6);
  static const Color buttonDisabled = Color(0xFFE5E7EB);
  
  // Input Colors
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputFocused = Color(0xFF1976D2);    // Using main blue
  static const Color inputError = Color(0xFFDC2626);
  
  // Attendance Stats Colors (Subtle versions)
  static const Color attendanceGood = Color(0xFFECFDF5);    // Very light green bg
  static const Color attendanceAverage = Color(0xFFFEF3C7); // Very light yellow bg
  static const Color attendancePoor = Color(0xFFFEE2E2);    // Very light red bg
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFBFC), Color(0xFFF5F7FA)],
  );
}