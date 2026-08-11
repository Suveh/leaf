import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';
import 'community_tip.dart';

/// Read-only scrollable feed of community-submitted plant care tips.
/// Dummy data only — no posting or liking functionality yet.
class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Tips')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyCommunityTips.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _TipCard(tip: dummyCommunityTips[index]),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final CommunityTip tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.placeholderFill,
              foregroundColor: AppColors.primaryGreen,
              child: Text(
                tip.userName.isEmpty ? '?' : tip.userName[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(tip.tipText, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: AppColors.earthBrown,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${tip.likeCount}',
                        style: const TextStyle(color: AppColors.earthBrown),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
