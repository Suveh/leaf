import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';

enum CareDifficulty { easy, moderate, hard }

extension CareDifficultyDisplay on CareDifficulty {
  String get label => switch (this) {
    CareDifficulty.easy => 'Easy',
    CareDifficulty.moderate => 'Moderate',
    CareDifficulty.hard => 'Hard',
  };

  Color get color => switch (this) {
    CareDifficulty.easy => AppColors.primaryGreen,
    CareDifficulty.moderate => AppColors.wateringAmber,
    CareDifficulty.hard => AppColors.overdueRed,
  };
}

/// A houseplant species entry in the care library. Dummy/reference data
/// only — not tied to any of the user's own tracked plants.
class PlantLibraryEntry {
  const PlantLibraryEntry({
    required this.name,
    required this.species,
    required this.difficulty,
    required this.careBlurb,
  });

  final String name;
  final String species;
  final CareDifficulty difficulty;
  final String careBlurb;
}

const dummyPlantLibrary = <PlantLibraryEntry>[
  PlantLibraryEntry(
    name: 'Snake Plant',
    species: 'Dracaena trifasciata',
    difficulty: CareDifficulty.easy,
    careBlurb:
        'Tolerates low light and infrequent watering — let the soil dry '
        'fully between waterings.',
  ),
  PlantLibraryEntry(
    name: 'Pothos',
    species: 'Epipremnum aureum',
    difficulty: CareDifficulty.easy,
    careBlurb:
        'Thrives in most light levels; water when the top inch of soil '
        'feels dry.',
  ),
  PlantLibraryEntry(
    name: 'ZZ Plant',
    species: 'Zamioculcas zamiifolia',
    difficulty: CareDifficulty.easy,
    careBlurb: 'Extremely drought-tolerant; water only every 2-3 weeks.',
  ),
  PlantLibraryEntry(
    name: 'Aloe Vera',
    species: 'Aloe vera',
    difficulty: CareDifficulty.easy,
    careBlurb:
        'Loves bright light and deep, infrequent watering; let soil dry '
        'out fully between waterings.',
  ),
  PlantLibraryEntry(
    name: 'Monstera Deliciosa',
    species: 'Monstera deliciosa',
    difficulty: CareDifficulty.moderate,
    careBlurb:
        'Bright indirect light and weekly watering; likes to climb a '
        'moss pole as it grows.',
  ),
  PlantLibraryEntry(
    name: 'Peace Lily',
    species: 'Spathiphyllum wallisii',
    difficulty: CareDifficulty.moderate,
    careBlurb:
        'Droops visibly when thirsty; keep soil consistently moist, '
        'not soggy.',
  ),
  PlantLibraryEntry(
    name: 'Spider Plant',
    species: 'Chlorophytum comosum',
    difficulty: CareDifficulty.moderate,
    careBlurb:
        'Easygoing but appreciates bright, indirect light and even soil '
        'moisture.',
  ),
  PlantLibraryEntry(
    name: 'Fiddle Leaf Fig',
    species: 'Ficus lyrata',
    difficulty: CareDifficulty.hard,
    careBlurb:
        'Picky about light changes and overwatering; keep in bright '
        'indirect light and a consistent spot.',
  ),
  PlantLibraryEntry(
    name: 'Boston Fern',
    species: 'Nephrolepis exaltata',
    difficulty: CareDifficulty.hard,
    careBlurb:
        'Needs high humidity and consistently moist soil — mist '
        'regularly or use a pebble tray.',
  ),
  PlantLibraryEntry(
    name: 'Calathea',
    species: 'Calathea orbifolia',
    difficulty: CareDifficulty.hard,
    careBlurb:
        'Sensitive to tap water and dry air; use filtered water and a '
        'humidifier if possible.',
  ),
];
