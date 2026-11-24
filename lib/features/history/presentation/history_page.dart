import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';
import '../../../l10n/generated/app_localizations.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderPage(
      title: l10n.historyTitle,
      description: l10n.historyDescription,
      emptyMessage: l10n.historyEmpty,
      icon: Icons.history_rounded,
    );
  }
}
