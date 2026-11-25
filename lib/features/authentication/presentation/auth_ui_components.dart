import 'package:flutter/material.dart';

import '../../../shared/widgets/organic_green_background.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrganicGreenBackground(
      variant: OrganicBackgroundVariant.auth,
      child: child,
    );
  }
}
