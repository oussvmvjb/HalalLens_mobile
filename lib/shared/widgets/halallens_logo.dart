import 'package:flutter/material.dart';

class HalalLensLogo extends StatelessWidget {
  const HalalLensLogo({required this.width, required this.height, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/halallens_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'HalalLens',
    );
  }
}
