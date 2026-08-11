/// A single photo log entry. Dummy/in-memory only — there is no real photo
/// capture or storage yet.
class PhotoLogEntry {
  const PhotoLogEntry({required this.id, required this.takenOn});

  final String id;
  final DateTime takenOn;
}

/// Deterministic dummy photo history so every plant has something to show
/// in its photo log before real photo capture is implemented.
List<PhotoLogEntry> dummyPhotoLog(String plantId) {
  final seed = plantId.hashCode.abs();
  final count = 3 + (seed % 4); // 3-6 dummy photos
  final now = DateTime.now();

  return List.generate(count, (index) {
    final daysAgo = (index + 1) * 5;
    return PhotoLogEntry(
      id: '${plantId}_photo_$index',
      takenOn: now.subtract(Duration(days: daysAgo)),
    );
  });
}
