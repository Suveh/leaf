import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';
import 'photo_log_entry.dart';

/// Grid of a plant's photo history. UI only — the "Add Photo" action is a
/// stub; it doesn't access the camera or gallery yet.
class PhotoLogScreen extends StatelessWidget {
  const PhotoLogScreen({
    super.key,
    required this.plantId,
    required this.plantName,
  });

  final String plantId;
  final String plantName;

  @override
  Widget build(BuildContext context) {
    final entries = dummyPhotoLog(plantId);

    return Scaffold(
      appBar: AppBar(title: Text('$plantName Photos')),
      body: entries.isEmpty
          ? const Center(child: Text('No photos yet.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) =>
                  _PhotoThumbnail(entry: entries[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera/gallery access not implemented yet'),
            ),
          );
        },
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Add Photo'),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({required this.entry});

  final PhotoLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.placeholderFill),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_outlined,
              color: AppColors.primaryGreen,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(entry.takenOn),
              style: const TextStyle(fontSize: 11, color: AppColors.soilBrown),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}';
}
