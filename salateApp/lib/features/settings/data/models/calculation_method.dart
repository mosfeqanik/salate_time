/// The prayer-time calculation methods offered in Settings, mapped to their
/// Aladhan API `method` id (https://aladhan.com/prayer-times-api — "Method
/// Options"). Matches the list shown in the reference SettingsTab design.
class CalculationMethod {
  const CalculationMethod({required this.id, required this.label});

  final int id;
  final String label;

  static const isna = CalculationMethod(id: 2, label: 'Islamic Society of North America (ISNA)');
  static const mwl = CalculationMethod(id: 3, label: 'Muslim World League (MWL)');
  static const egyptian = CalculationMethod(id: 5, label: 'Egyptian General Authority of Survey');
  static const ummAlQura = CalculationMethod(id: 4, label: 'Umm al-Qura University, Makkah');
  static const karachi = CalculationMethod(id: 1, label: 'University of Islamic Sciences, Karachi');

  static const all = [isna, mwl, egyptian, ummAlQura, karachi];

  static const defaultMethod = mwl;

  static CalculationMethod fromId(int id) => all.firstWhere((m) => m.id == id, orElse: () => defaultMethod);
}
