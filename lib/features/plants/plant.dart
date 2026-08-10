/// A single houseplant. Currently backed by in-memory dummy data — no
/// persistence layer yet.
class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.species,
    this.imagePath,
    this.needsWateringToday = false,
  });

  final String id;
  final String name;
  final String species;

  /// Path/URL to a photo of the plant. Null until the photo picker is
  /// implemented — screens fall back to a placeholder graphic.
  final String? imagePath;

  final bool needsWateringToday;

  Plant copyWith({
    String? name,
    String? species,
    String? imagePath,
    bool? needsWateringToday,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      imagePath: imagePath ?? this.imagePath,
      needsWateringToday: needsWateringToday ?? this.needsWateringToday,
    );
  }
}
