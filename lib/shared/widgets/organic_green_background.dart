import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum OrganicBackgroundVariant {
  auth,
  home,
  scanner,
  analysis,
  history,
  settings,
}

class OrganicGreenBackground extends StatelessWidget {
  const OrganicGreenBackground({
    required this.child,
    this.variant = OrganicBackgroundVariant.home,
    super.key,
  });

  final Widget child;
  final OrganicBackgroundVariant variant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.white),
        IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _OrganicGreenPainter(variant: variant),
              size: Size.infinite,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _OrganicGreenPainter extends CustomPainter {
  const _OrganicGreenPainter({required this.variant});

  final OrganicBackgroundVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final softMint = Paint()..color = AppTheme.secondaryBackground;
    final pastelMint =
        Paint()..color = AppTheme.lightGreen.withValues(alpha: 0.76);
    final accentGreen =
        Paint()..color = AppTheme.primaryGreen.withValues(alpha: 0.14);

    switch (variant) {
      case OrganicBackgroundVariant.auth:
        _paintAuth(canvas, w, h, softMint, pastelMint, accentGreen);
      case OrganicBackgroundVariant.home:
        _paintHome(canvas, w, h, softMint, pastelMint, accentGreen);
      case OrganicBackgroundVariant.scanner:
        _paintScanner(canvas, w, h, softMint, pastelMint, accentGreen);
      case OrganicBackgroundVariant.analysis:
        _paintAnalysis(canvas, w, h, softMint, pastelMint, accentGreen);
      case OrganicBackgroundVariant.history:
        _paintHistory(canvas, w, h, softMint, pastelMint, accentGreen);
      case OrganicBackgroundVariant.settings:
        _paintSettings(canvas, w, h, softMint, pastelMint, accentGreen);
    }
  }

  void _paintAuth(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    final topMain =
        Path()
          ..moveTo(0, 0)
          ..lineTo(w * 0.62, 0)
          ..cubicTo(w * 0.78, h * 0.08, w * 0.80, h * 0.21, w * 0.56, h * 0.25)
          ..cubicTo(w * 0.36, h * 0.285, w * 0.16, h * 0.27, 0, h * 0.285)
          ..close();
    canvas.drawPath(topMain, pastelMint);

    final topAccent =
        Path()
          ..moveTo(0, 0)
          ..lineTo(w * 0.44, 0)
          ..cubicTo(w * 0.56, h * 0.055, w * 0.54, h * 0.155, w * 0.34, h * 0.19)
          ..cubicTo(w * 0.19, h * 0.215, w * 0.08, h * 0.205, 0, h * 0.22)
          ..close();
    canvas.drawPath(topAccent, accentGreen);

    final bottomSoft =
        Path()
          ..moveTo(w, h * 0.50)
          ..cubicTo(w * 0.78, h * 0.54, w * 0.72, h * 0.72, w * 0.54, h * 0.84)
          ..cubicTo(w * 0.40, h * 0.93, w * 0.22, h * 0.91, w * 0.06, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomSoft, softMint);

    final bottomMain =
        Path()
          ..moveTo(w, h * 0.57)
          ..cubicTo(w * 0.82, h * 0.62, w * 0.77, h * 0.77, w * 0.60, h * 0.88)
          ..cubicTo(w * 0.47, h * 0.96, w * 0.32, h * 0.95, w * 0.18, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomMain, pastelMint);

    final bottomAccent =
        Path()
          ..moveTo(w, h * 0.70)
          ..cubicTo(w * 0.87, h * 0.76, w * 0.82, h * 0.88, w * 0.65, h * 0.95)
          ..cubicTo(w * 0.56, h * 0.985, w * 0.48, h * 0.985, w * 0.40, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomAccent, accentGreen);
  }

  void _paintHome(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    // Top-right sweeping organic wave
    final topRight =
        Path()
          ..moveTo(w * 0.30, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.27)
          ..cubicTo(w * 0.82, h * 0.25, w * 0.66, h * 0.22, w * 0.46, h * 0.17)
          ..cubicTo(w * 0.28, h * 0.125, w * 0.22, h * 0.05, w * 0.30, 0)
          ..close();
    canvas.drawPath(topRight, pastelMint);

    final topRightAccent =
        Path()
          ..moveTo(w * 0.52, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.18)
          ..cubicTo(w * 0.84, h * 0.17, w * 0.66, h * 0.14, w * 0.54, h * 0.09)
          ..cubicTo(w * 0.46, h * 0.055, w * 0.47, h * 0.02, w * 0.52, 0)
          ..close();
    canvas.drawPath(topRightAccent, accentGreen);

    // Bottom-left rising organic curve
    final bottomLeftSoft =
        Path()
          ..moveTo(0, h * 0.56)
          ..cubicTo(w * 0.24, h * 0.60, w * 0.30, h * 0.77, w * 0.52, h * 0.86)
          ..cubicTo(w * 0.70, h * 0.94, w * 0.84, h * 0.93, w * 0.94, h)
          ..lineTo(0, h)
          ..close();
    canvas.drawPath(bottomLeftSoft, softMint);

    final bottomLeftMain =
        Path()
          ..moveTo(0, h * 0.65)
          ..cubicTo(w * 0.20, h * 0.70, w * 0.24, h * 0.83, w * 0.44, h * 0.91)
          ..cubicTo(w * 0.58, h * 0.965, w * 0.70, h * 0.97, w * 0.78, h)
          ..lineTo(0, h)
          ..close();
    canvas.drawPath(bottomLeftMain, pastelMint);
  }

  void _paintScanner(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    // Top gentle arch sweeping across the header area
    final topArch =
        Path()
          ..moveTo(0, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.16)
          ..cubicTo(w * 0.76, h * 0.22, w * 0.46, h * 0.14, w * 0.20, h * 0.20)
          ..cubicTo(w * 0.09, h * 0.225, w * 0.03, h * 0.21, 0, h * 0.19)
          ..close();
    canvas.drawPath(topArch, softMint);

    final topRightPill =
        Path()
          ..moveTo(w * 0.58, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.12)
          ..cubicTo(w * 0.85, h * 0.14, w * 0.68, h * 0.09, w * 0.58, 0)
          ..close();
    canvas.drawPath(topRightPill, pastelMint);

    // Bottom-right soft wave
    final bottomWave =
        Path()
          ..moveTo(w, h * 0.62)
          ..cubicTo(w * 0.78, h * 0.66, w * 0.74, h * 0.82, w * 0.52, h * 0.90)
          ..cubicTo(w * 0.38, h * 0.95, w * 0.26, h * 0.97, w * 0.16, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomWave, pastelMint);

    final bottomAccent =
        Path()
          ..moveTo(w, h * 0.74)
          ..cubicTo(w * 0.86, h * 0.79, w * 0.80, h * 0.90, w * 0.62, h * 0.96)
          ..cubicTo(w * 0.52, h * 0.99, w * 0.44, h * 0.99, w * 0.36, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomAccent, accentGreen);
  }

  void _paintAnalysis(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    // Mid-left flowing side wave
    final leftFlow =
        Path()
          ..moveTo(0, h * 0.14)
          ..cubicTo(w * 0.22, h * 0.18, w * 0.26, h * 0.36, w * 0.14, h * 0.50)
          ..cubicTo(w * 0.05, h * 0.60, w * 0.12, h * 0.74, 0, h * 0.82)
          ..close();
    canvas.drawPath(leftFlow, softMint);

    final leftAccent =
        Path()
          ..moveTo(0, h * 0.22)
          ..cubicTo(w * 0.14, h * 0.26, w * 0.16, h * 0.38, w * 0.08, h * 0.49)
          ..cubicTo(w * 0.03, h * 0.56, w * 0.04, h * 0.64, 0, h * 0.69)
          ..close();
    canvas.drawPath(leftAccent, accentGreen);

    // Top-right soft corner wave
    final topRight =
        Path()
          ..moveTo(w * 0.48, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.22)
          ..cubicTo(w * 0.82, h * 0.20, w * 0.64, h * 0.14, w * 0.48, 0)
          ..close();
    canvas.drawPath(topRight, pastelMint);

    // Bottom-right subtle curve
    final bottomRight =
        Path()
          ..moveTo(w, h * 0.72)
          ..cubicTo(w * 0.82, h * 0.76, w * 0.72, h * 0.90, w * 0.48, h)
          ..lineTo(w, h)
          ..close();
    canvas.drawPath(bottomRight, pastelMint);
  }

  void _paintHistory(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    // Top-left slim organic curve
    final topLeft =
        Path()
          ..moveTo(0, 0)
          ..lineTo(w * 0.55, 0)
          ..cubicTo(w * 0.45, h * 0.10, w * 0.24, h * 0.14, 0, h * 0.22)
          ..close();
    canvas.drawPath(topLeft, pastelMint);

    // Right-side mid gentle curve
    final rightMid =
        Path()
          ..moveTo(w, h * 0.26)
          ..cubicTo(w * 0.80, h * 0.32, w * 0.78, h * 0.50, w, h * 0.58)
          ..close();
    canvas.drawPath(rightMid, softMint);

    // Bottom-left sweeping wave
    final bottomLeft =
        Path()
          ..moveTo(0, h * 0.68)
          ..cubicTo(w * 0.26, h * 0.72, w * 0.36, h * 0.86, w * 0.68, h * 0.93)
          ..cubicTo(w * 0.82, h * 0.96, w * 0.90, h * 0.98, w * 0.96, h)
          ..lineTo(0, h)
          ..close();
    canvas.drawPath(bottomLeft, pastelMint);

    final bottomAccent =
        Path()
          ..moveTo(0, h * 0.79)
          ..cubicTo(w * 0.20, h * 0.83, w * 0.30, h * 0.92, w * 0.54, h)
          ..lineTo(0, h)
          ..close();
    canvas.drawPath(bottomAccent, accentGreen);
  }

  void _paintSettings(
    Canvas canvas,
    double w,
    double h,
    Paint softMint,
    Paint pastelMint,
    Paint accentGreen,
  ) {
    // Top-right soft wave
    final topRight =
        Path()
          ..moveTo(w * 0.38, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.24)
          ..cubicTo(w * 0.76, h * 0.21, w * 0.56, h * 0.15, w * 0.38, 0)
          ..close();
    canvas.drawPath(topRight, softMint);

    final topRightAccent =
        Path()
          ..moveTo(w * 0.62, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.15)
          ..cubicTo(w * 0.84, h * 0.14, w * 0.70, h * 0.08, w * 0.62, 0)
          ..close();
    canvas.drawPath(topRightAccent, accentGreen);

    // Bottom balanced dual wave
    final bottomWave =
        Path()
          ..moveTo(0, h * 0.76)
          ..cubicTo(w * 0.28, h * 0.68, w * 0.64, h * 0.88, w, h * 0.70)
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close();
    canvas.drawPath(bottomWave, pastelMint);
  }

  @override
  bool shouldRepaint(covariant _OrganicGreenPainter oldDelegate) =>
      oldDelegate.variant != variant;
}
