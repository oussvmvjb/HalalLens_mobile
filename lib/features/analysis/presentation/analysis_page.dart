import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';
import '../../../l10n/generated/app_localizations.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderPage(
      title: l10n.analysisTitle,
      description: l10n.analysisDescription,
      icon: Icons.fact_check_rounded,
    );
  }
}
