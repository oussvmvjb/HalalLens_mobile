import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/history_repository.dart';
import '../domain/scan_history.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _scrollController = ScrollController();
  final _items = <ScanHistoryItem>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_loadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ref
          .read(historyRepositoryProvider)
          .fetchHistory(limit: 20, offset: 0);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(items);
        _hasMore = items.length == 20;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final items = await ref.read(historyRepositoryProvider).fetchHistory(
            limit: 20,
            offset: _items.length,
          );
      if (!mounted) return;
      setState(() {
        _items.addAll(items);
        _hasMore = items.length == 20;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasMore = false;
        _loadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _items.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline),
                            const SizedBox(height: 12),
                            const Text('Could not load scan history.'),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _load,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : _items.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.history_rounded),
                                SizedBox(height: 12),
                                Text('No scan history yet'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length + (_loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _HistoryCard(item: _items[index]);
                      },
                    ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.item});

  final ScanHistoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final statusColor = switch (item.analysis.overallStatus) {
      'HALAL_VERIFIED' => Colors.green,
      'HARAM_FLAG' => Colors.red,
      'DOUBTFUL' => Colors.orange,
      'PROCESSING' => Colors.blue,
      'FAILED' => Colors.redAccent,
      _ => Colors.grey,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final details = await ref
              .read(historyRepositoryProvider)
              .fetchDetails(item.id);
          if (!context.mounted) return;
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              builder: (_, controller) => _ScanDetailsSheet(
                details: details,
                controller: controller,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: product.imageUrl == null
                      ? const ColoredBox(
                          color: Color(0xFFEAF4EF),
                          child: Icon(Icons.inventory_2_outlined),
                        )
                      : Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.inventory_2_outlined,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Product information unavailable',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (product.brand != null)
                      Text(product.brand!, style: Theme.of(context).textTheme.bodySmall),
                    if (item.barcode != null) Text(item.barcode!),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(item.scanStatus),
                          visualDensity: VisualDensity.compact,
                        ),
                        Chip(
                          avatar: Icon(Icons.circle, size: 10, color: statusColor),
                          label: Text(item.analysis.overallStatus),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    Text(
                      '${item.createdAt.toLocal()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanDetailsSheet extends StatelessWidget {
  const _ScanDetailsSheet({
    required this.details,
    required this.controller,
  });

  final ScanDetails details;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final product = details.product;
    final analysis = details.analysis;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          product.name ?? 'Product information unavailable',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (product.brand != null) Text(product.brand!),
        if (details.barcode != null) Text('Barcode: ${details.barcode}'),
        const SizedBox(height: 16),
        Text(
          analysis.overallStatus,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (analysis.confidenceScore != null)
          Text('Confidence: ${analysis.confidenceScore}'),
        Text(analysis.explanation),
        if (product.ingredientsText != null) ...[
          const SizedBox(height: 16),
          Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
          Text(product.ingredientsText!),
        ],
        if (product.nutriments.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Nutrition', style: Theme.of(context).textTheme.titleMedium),
          Text(product.nutriments.entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join('\n')),
        ],
        if (analysis.certifications.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Certifications', style: Theme.of(context).textTheme.titleMedium),
          for (final certification in analysis.certifications)
            Text(certification.entries
                .map((entry) => '${entry.key}: ${entry.value}')
                .join('\n')),
        ],
        if (analysis.warnings.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Warnings', style: Theme.of(context).textTheme.titleMedium),
          for (final warning in analysis.warnings) Text(warning),
        ],
        if (details.originalIngredientsText != null) ...[
          const SizedBox(height: 16),
          Text('Original OCR text',
              style: Theme.of(context).textTheme.titleMedium),
          Text(details.originalIngredientsText!),
        ],
        const SizedBox(height: 16),
        Text('Scanned: ${details.createdAt.toLocal()}'),
      ],
    );
  }
}
