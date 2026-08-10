/// A single houseplant. Currently backed by in-memory dummy data — no
/// persistence layer yet.
class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.nextWateringDate,
    this.imagePath,
  });

  final String id;
  final String name;
  final String species;

  /// The next date this plant is due to be watered. Watering status
  /// (overdue / due today / upcoming) is derived from this rather than
  /// stored separately, so it can never drift out of sync.
  final DateTime nextWateringDate;

  /// Path/URL to a photo of the plant. Null until the photo picker is
  /// implemented — screens fall back to a placeholder graphic.
  final String? imagePath;

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool get isOverdue =>
      _dateOnly(nextWateringDate).isBefore(_dateOnly(DateTime.now()));

  bool get needsWateringToday =>
      !_dateOnly(nextWateringDate).isAfter(_dateOnly(DateTime.now()));

  Plant copyWith({
    String? name,
    String? species,
    DateTime? nextWateringDate,
    String? imagePath,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      nextWateringDate: nextWateringDate ?? this.nextWateringDate,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
