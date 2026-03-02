import 'package:flutter/material.dart';

/// MindHause Greco-Roman inspired theme
/// Warm, intellectual, inviting — like a well-maintained villa
class MindHauseTheme {
  // Greco-Roman colour palette
  static const Color marble = Color(0xFFF5F0E8);
  static const Color warmStone = Color(0xFFD4C5A9);
  static const Color terracotta = Color(0xFFB87333);
  static const Color deepOlive = Color(0xFF556B2F);
  static const Color bronzeGold = Color(0xFFC5943A);
  static const Color inkDark = Color(0xFF2C2416);
  static const Color parchment = Color(0xFFFAF6EE);
  static const Color slateBlue = Color(0xFF4A5568);
  static const Color urgentRed = Color(0xFFC0392B);
  static const Color completedGold = Color(0xFFD4A843);

  // Priority colours (match HUD reticule)
  static const Color priorityLow = Color(0xFF68A357);
  static const Color priorityNormal = Color(0xFFD4A843);
  static const Color priorityHigh = Color(0xFFC0392B);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.light,
      surface: parchment,
      primary: terracotta,
      secondary: deepOlive,
      tertiary: bronzeGold,
      error: urgentRed,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: marble,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: inkDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'Serif',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: inkDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: parchment,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: terracotta,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: warmStone),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: warmStone),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: terracotta, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: warmStone.withValues(alpha: 0.3),
        selectedColor: terracotta.withValues(alpha: 0.2),
        labelStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: parchment,
        selectedItemColor: terracotta,
        unselectedItemColor: slateBlue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.dark,
      primary: bronzeGold,
      secondary: deepOlive,
      tertiary: terracotta,
      error: urgentRed,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Serif',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: bronzeGold,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Get priority colour
  static Color priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return priorityHigh;
      case 'low':
        return priorityLow;
      default:
        return priorityNormal;
    }
  }

  /// Get room icon
  /// Monster state color for badges and indicators
  static Color monsterColor(String state) {
    switch (state) {
      case 'neglected':
        return priorityNormal;
      case 'corrupting':
        return const Color(0xFFFF5722);
      case 'monster':
        return urgentRed;
      default:
        return warmStone;
    }
  }

  static IconData roomIcon(String roomId) {
    switch (roomId) {
      case 'foyer':
        return Icons.home;
      case 'study':
        return Icons.work;
      case 'library':
        return Icons.menu_book;
      case 'kitchen':
        return Icons.kitchen;
      case 'workshop':
        return Icons.build;
      case 'garden':
        return Icons.park;
      case 'bedroom':
        return Icons.bed;
      case 'gymnasium':
        return Icons.fitness_center;
      case 'treasury':
        return Icons.emoji_events;
      case 'cellar':
        return Icons.inventory_2;
      default:
        return Icons.room;
    }
  }
}

/// Palace aesthetic theme — one of 8 house visual themes.
/// Each theme defines colors that map to Godot room materials.
class PalaceTheme {
  final String id;
  final String name;
  final String atmosphere;
  final String catDescription;
  final Color wallColor;
  final Color floorColor;
  final Color accentColor;
  final List<Color> palette;

  const PalaceTheme({
    required this.id,
    required this.name,
    required this.atmosphere,
    required this.catDescription,
    required this.wallColor,
    required this.floorColor,
    required this.accentColor,
    required this.palette,
  });

  static const all = <PalaceTheme>[
    PalaceTheme(
      id: 'greco_roman',
      name: 'Greco-Roman Classic',
      atmosphere: 'Grand, sunlit, classical',
      catDescription: 'Pale cream, gold collar',
      wallColor: Color(0xFFF2EBDE),
      floorColor: Color(0xFFEBE0D1),
      accentColor: Color(0xFFB87333),
      palette: [
        Color(0xFFF5F0E8), Color(0xFFD4C5A9), Color(0xFFB87333),
        Color(0xFFC5943A), Color(0xFF556B2F),
      ],
    ),
    PalaceTheme(
      id: 'modern_loft',
      name: 'Modern Loft',
      atmosphere: 'Sleek, urban, focused',
      catDescription: 'Steel-blue short hair',
      wallColor: Color(0xFF4D4D52),
      floorColor: Color(0xFF737373),
      accentColor: Color(0xFF1E90FF),
      palette: [
        Color(0xFF333338), Color(0xFF737373), Color(0xFFF0F0F5),
        Color(0xFF1E90FF), Color(0xFF2C2C30),
      ],
    ),
    PalaceTheme(
      id: 'victorian',
      name: 'Victorian Scholar',
      atmosphere: 'Warm, academic, intimate',
      catDescription: 'Dark tabby, scholarly',
      wallColor: Color(0xFF335933),
      floorColor: Color(0xFF594026),
      accentColor: Color(0xFFCD9B1D),
      palette: [
        Color(0xFF335933), Color(0xFF8B1A1A), Color(0xFF594026),
        Color(0xFFCD9B1D), Color(0xFFDAA520),
      ],
    ),
    PalaceTheme(
      id: 'scifi',
      name: 'Sci-Fi Minimal',
      atmosphere: 'Clean, futuristic, organized',
      catDescription: 'White/silver, holographic collar',
      wallColor: Color(0xFFF2F2F7),
      floorColor: Color(0xFFE8E8ED),
      accentColor: Color(0xFF00E5FF),
      palette: [
        Color(0xFFF8F8FF), Color(0xFFE0E0E5), Color(0xFF00E5FF),
        Color(0xFF808080), Color(0xFFB0B0B8),
      ],
    ),
    PalaceTheme(
      id: 'gothic',
      name: 'Gothic Cathedral',
      atmosphere: 'Awe-inspiring, scholarly',
      catDescription: 'Long-haired black, shadowy',
      wallColor: Color(0xFF666159),
      floorColor: Color(0xFF4D4740),
      accentColor: Color(0xFF7B2D8E),
      palette: [
        Color(0xFF4D4740), Color(0xFF666159), Color(0xFF7B2D8E),
        Color(0xFF191970), Color(0xFFDAA520),
      ],
    ),
    PalaceTheme(
      id: 'ryokan',
      name: 'Japanese Ryokan',
      atmosphere: 'Tranquil, meditative',
      catDescription: 'Calico Japanese bobtail',
      wallColor: Color(0xFFE6DECC),
      floorColor: Color(0xFFB8A673),
      accentColor: Color(0xFFFFB7C5),
      palette: [
        Color(0xFFE6DECC), Color(0xFFB8A673), Color(0xFFFFB7C5),
        Color(0xFF6B8E23), Color(0xFFDEB887),
      ],
    ),
    PalaceTheme(
      id: 'cottage',
      name: 'Countryside Cottage',
      atmosphere: 'Cozy, nurturing, creative',
      catDescription: 'Ginger fluffy, chunky',
      wallColor: Color(0xFFEBE0D1),
      floorColor: Color(0xFF997A52),
      accentColor: Color(0xFF87AE73),
      palette: [
        Color(0xFFEBE0D1), Color(0xFFDAA520), Color(0xFF87AE73),
        Color(0xFFB87333), Color(0xFF997A52),
      ],
    ),
    PalaceTheme(
      id: 'fallout',
      name: 'Fallout Bunker',
      atmosphere: 'Gritty, resourceful, survival',
      catDescription: 'Scrappy one-eared tabby',
      wallColor: Color(0xFF806652),
      floorColor: Color(0xFF59544D),
      accentColor: Color(0xFF39FF14),
      palette: [
        Color(0xFF806652), Color(0xFF59544D), Color(0xFF39FF14),
        Color(0xFF556B2F), Color(0xFFFFD700),
      ],
    ),
  ];

  static PalaceTheme byId(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all.first);
  }
}
