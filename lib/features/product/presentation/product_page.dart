import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderPage(
      title: l10n.productTitle,
      description: l10n.productDescription,
      icon: Icons.inventory_2_outlined,
    );
  }
}
