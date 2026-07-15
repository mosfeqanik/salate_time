/// A day's prayer schedule, parsed from Aladhan's `/v1/timingsByCity`
/// response `data` object. Doubles as both DTO and UI-facing entity (v1
/// skips a separate domain layer — see docs/architecture.md).
class PrayerTimings {
  const PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.readableDate,
  });

  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String readableDate;

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final date = json['date'] as Map<String, dynamic>;
    return PrayerTimings(
      fajr: _stripTimezone(timings['Fajr'] as String),
      sunrise: _stripTimezone(timings['Sunrise'] as String),
      dhuhr: _stripTimezone(timings['Dhuhr'] as String),
      asr: _stripTimezone(timings['Asr'] as String),
      maghrib: _stripTimezone(timings['Maghrib'] as String),
      isha: _stripTimezone(timings['Isha'] as String),
      readableDate: date['readable'] as String,
    );
  }

  /// Aladhan sometimes appends `" (TZ)"` to the "HH:mm" string; strip it.
  static String _stripTimezone(String raw) => raw.split(' ').first;

  /// The five daily prayers in schedule order, paired with their display name.
  List<MapEntry<String, String>> get schedule => [
        MapEntry('Fajr', fajr),
        MapEntry('Dhuhr', dhuhr),
        MapEntry('Asr', asr),
        MapEntry('Maghrib', maghrib),
        MapEntry('Isha', isha),
      ];
}
