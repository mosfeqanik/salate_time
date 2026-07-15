import '../data/models/prayer_timings.dart';

/// Derived "where are we in today's schedule" info for the home screen's
/// hero card: which prayer is current, which is next, how far through the
/// current window we are, and the countdown to the next one.
class PrayerScheduleStatus {
  const PrayerScheduleStatus({
    required this.currentName,
    required this.nextName,
    required this.nextStart,
    required this.percentElapsed,
    required this.remaining,
  });

  final String currentName;
  final String nextName;
  final DateTime nextStart;
  final double percentElapsed;
  final Duration remaining;

  String get remainingLabel {
    final h = remaining.inHours;
    final m = remaining.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class PrayerScheduleCalculator {
  const PrayerScheduleCalculator(this.timings);

  final PrayerTimings timings;

  PrayerScheduleStatus statusAt(DateTime now) {
    final entries = timings.schedule
        .map((e) => MapEntry(e.key, _parseToday(e.value, now)))
        .toList(growable: false);

    var currentIndex = entries.lastIndexWhere((e) => !now.isBefore(e.value));

    DateTime currentStart;
    if (currentIndex == -1) {
      // Before Fajr: still within "last night's" Isha window.
      currentIndex = entries.length - 1;
      currentStart = entries.last.value.subtract(const Duration(days: 1));
    } else {
      currentStart = entries[currentIndex].value;
    }

    final nextIndex = (currentIndex + 1) % entries.length;
    final wrapsToTomorrow = nextIndex == 0 && currentIndex != -1;
    final nextStart = wrapsToTomorrow
        ? entries[nextIndex].value.add(const Duration(days: 1))
        : entries[nextIndex].value;

    final windowSeconds = nextStart.difference(currentStart).inSeconds;
    final elapsedSeconds = now.difference(currentStart).inSeconds;
    final percent = windowSeconds == 0 ? 0.0 : (elapsedSeconds / windowSeconds).clamp(0.0, 1.0);

    return PrayerScheduleStatus(
      currentName: entries[currentIndex].key,
      nextName: entries[nextIndex].key,
      nextStart: nextStart,
      percentElapsed: percent,
      remaining: nextStart.difference(now),
    );
  }

  static DateTime _parseToday(String hhmm, DateTime now) {
    final parts = hhmm.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }
}
