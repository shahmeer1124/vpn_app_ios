import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorsConstants {
  static const gradient1 = LinearGradient(
    colors: [
      Color(0xFF24B1F7),
      Color(0xFF4671FD),
    ],
  );
  static const gradient2 = LinearGradient(
    colors: [
      Color(0xFFA3F725),
      Color(0xFFFDF146),
    ],
  );
  static const premiumGradient1 = LinearGradient(
    colors: [
      Color(0xFFFEFEFF),
      Color(0xFFE6F2FE),
    ],
  );

  static const Color primaryColor = Color(0xFF5D68F8);
  static const Color sidePanelBackColor = Color(0xFF333334);
  static const Color sidePanelChildColor = Color(0xFF4B4848);
  static const Color purpleColor = Color(0xFF691D99);
  static const Color kindOfBlue = Color(0xFF2f22E9);
  static Color mainBodyBgColor = const Color(0xFF1C1B21).withOpacity(0.9);
}

TextStyle appstyle(
  double? size,
  Color color,
  FontWeight? fw,
) {
  return GoogleFonts.poppins(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

TextStyle appstyle2(
  double? size,
  Color color,
  FontWeight? fw,
) {
  return GoogleFonts.quicksand(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

TextStyle appstyle3(
  double? size,
  Color color,
  FontWeight? fw,
) {
  return GoogleFonts.actor(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

Color getPingColor(String ping) {
  double pingValue = double.tryParse(ping) ?? 0;
  if (pingValue <= 50) {
    return Colors.green; // Good ping
  } else if (pingValue <= 100) {
    return Colors.yellow; // Moderate ping
  } else {
    return Colors.red; // Bad ping
  }
}

Color getSpeedColor(double speedInMbps) {
  if (speedInMbps >= 50) {
    return Colors.green; // High speed
  } else if (speedInMbps >= 10) {
    return Colors.yellow; // Moderate speed
  } else {
    return Colors.red; // Low speed
  }
}

Color getSessionsColor(int sessions) {
  if (sessions <= 1000) {
    return Colors.green; // Low sessions (good)
  } else if (sessions <= 5000) {
    return Colors.yellow; // Moderate sessions
  } else {
    return Colors.red; // High sessions (potentially bad)
  }
}
