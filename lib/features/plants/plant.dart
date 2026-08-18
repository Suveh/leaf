/// A single houseplant, backed by the Spring Boot backend's `/api/plants`
/// resource.
class Plant {
  const Plant({
    required this.id,
    required this.name,
    this.species,
    required this.wateringFrequencyDays,
    this.imagePath,
    this.lastWateredDate,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? species;

  /// How often this plant should be watered, in days. Mirrors the backend's
  /// `wateringFrequencyDays`.
  final int wateringFrequencyDays;

  /// Path/URL to a photo of the plant. Maps to the backend's `photoUrl`.
  /// Null until the photo picker is implemented — screens fall back to a
  /// placeholder graphic.
  final String? imagePath;

  /// The last time this plant was watered, as reported by the backend.
  /// Null if it has never been logged as watered.
  final DateTime? lastWateredDate;

  /// When the backend created this plant record. Null for a plant that
  /// hasn't been saved to the backend yet.
  final DateTime? createdAt;

  /// The next date this plant is due to be watered, derived from
  /// [lastWateredDate] (or [createdAt] if it's never been watered) plus
  /// [wateringFrequencyDays], so it can never drift out of sync with the
  /// backend's data.
  DateTime get nextWateringDate {
    final baseline = lastWateredDate ?? createdAt ?? DateTime.now();
    return _dateOnly(baseline).add(Duration(days: wateringFrequencyDays));
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool get isOverdue =>
      nextWateringDate.isBefore(_dateOnly(DateTime.now()));

  bool get needsWateringToday =>
      !nextWateringDate.isAfter(_dateOnly(DateTime.now()));

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'].toString(),
      name: json['name'] as String,
      species: json['species'] as String?,
      wateringFrequencyDays: json['wateringFrequencyDays'] as int,
      imagePath: json['photoUrl'] as String?,
      lastWateredDate: json['lastWateredDate'] == null
          ? null
          : DateTime.parse(json['lastWateredDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Serializes the fields the backend's `PlantRequest` accepts (create and
  /// update use the same shape; `id`/`createdAt` are server-assigned and
  /// never sent).
  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'species': species,
      'photoUrl': imagePath,
      'wateringFrequencyDays': wateringFrequencyDays,
      'lastWateredDate': lastWateredDate == null
          ? null
          : _formatDate(lastWateredDate!),
    };
  }

  static String _formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)}';
  }

  Plant copyWith({
    String? name,
    String? species,
    int? wateringFrequencyDays,
    String? imagePath,
    DateTime? lastWateredDate,
    DateTime? createdAt,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      wateringFrequencyDays: wateringFrequencyDays ?? this.wateringFrequencyDays,
      imagePath: imagePath ?? this.imagePath,
      lastWateredDate: lastWateredDate ?? this.lastWateredDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
