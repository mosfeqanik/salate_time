/// A single supplication (du'a) shown in the Dua tab.
///
/// Fields are intentionally simple — the list is hardcoded for v1, but the
/// shape mirrors what a future JSON/API-backed source would return.
class Dua {
  const Dua({
    required this.id,
    required this.title,
    required this.category,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
  });

  /// Stable identifier used as a list key and for deep-linking later.
  final String id;

  /// Short English title shown in lists, e.g. "Before Eating".
  final String title;

  /// Group label, e.g. "Daily", "Food", "Travel". Used to section the list.
  final String category;

  /// Arabic text of the du'a.
  final String arabic;

  /// Latin-script transliteration for non-Arabic readers.
  final String transliteration;

  /// English meaning.
  final String translation;

  /// Source citation, e.g. "Sahih al-Bukhari 5374".
  final String reference;
}

/// Categories used to group duas in the list view.
class DuaCategory {
  const DuaCategory._();

  static const daily = 'Daily';
  static const food = 'Food';
  static const travel = 'Travel';
  static const sleep = 'Sleep';
  static const prayer = 'Prayer';
  static const distress = 'Hardship & Anxiety';
  static const forgiveness = 'Forgiveness';
}