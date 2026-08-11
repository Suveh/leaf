import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_data.dart';
import 'plant_library_entry.dart';
import 'plant_library_search_model.dart';

/// Searchable reference library of common houseplant species. Dummy data
/// only — not connected to the user's own tracked plants.
class PlantLibraryScreen extends StatelessWidget {
  const PlantLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantLibrarySearchModel(),
      child: const _PlantLibraryBody(),
    );
  }
}

class _PlantLibraryBody extends StatelessWidget {
  const _PlantLibraryBody();

  @override
  Widget build(BuildContext context) {
    final searchModel = context.watch<PlantLibrarySearchModel>();
    final results = searchModel.results;

    return Scaffold(
      appBar: AppBar(title: const Text('Plant Library')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchModel.queryController,
              decoration: const InputDecoration(
                hintText: 'Search plants by name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No plants match your search.'))
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _PlantLibraryCard(entry: results[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantLibraryCard extends StatelessWidget {
  const _PlantLibraryCard({required this.entry});

  final PlantLibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _DifficultyTag(difficulty: entry.difficulty),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              entry.species,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(entry.careBlurb, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _DifficultyTag extends StatelessWidget {
  const _DifficultyTag({required this.difficulty});

  final CareDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = difficulty.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
