import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    required this.description,
    this.links = const {},
    super.key,
  });

  final String title;
  final String description;
  final Map<String, String> links;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
          for (final entry in links.entries)
            ListTile(
              title: Text(entry.key),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(entry.value),
            ),
        ],
      ),
    );
  }
}
