import 'package:flutter/material.dart';

/// iconKey → IconData and colorKey → Color mappings.
///
/// Categories store keys, not values, so exports stay stable
/// (ARCHITECTURE.md §6 `categories.iconKey/colorKey`).

const Map<String, Color> categoryColorKeys = <String, Color>{
  'dawn': Color(0xFFF4A261),
  'gold': Color(0xFFFFC857),
  'blue': Color(0xFF4A6FB5),
  'green': Color(0xFF6FCF97),
  'teal': Color(0xFF64D2C3),
  'purple': Color(0xFFA78BFA),
  'coral': Color(0xFFFF8B7B),
  'lavender': Color(0xFFC9A7FF),
};

/// Icon keys offered when creating a custom category.
const List<String> selectableIconKeys = <String>[
  'spiritual',
  'mind',
  'body',
  'home',
  'create',
  'plan',
  'book',
  'music',
  'heart',
  'star',
  'leaf',
  'bolt',
];

IconData iconForKey(String key) => switch (key) {
      'spiritual' => Icons.self_improvement,
      'mind' => Icons.psychology_outlined,
      'body' => Icons.fitness_center,
      'home' => Icons.home_outlined,
      'create' => Icons.palette_outlined,
      'plan' => Icons.event_note_outlined,
      'book' => Icons.menu_book_outlined,
      'music' => Icons.music_note_outlined,
      'heart' => Icons.favorite_border,
      'star' => Icons.star_border,
      'leaf' => Icons.eco_outlined,
      'bolt' => Icons.bolt_outlined,
      _ => Icons.circle_outlined,
    };

Color colorForKey(String key) => categoryColorKeys[key] ?? categoryColorKeys['dawn']!;
