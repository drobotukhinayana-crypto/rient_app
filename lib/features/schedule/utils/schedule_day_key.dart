/// Ключ дня недели в шаблонах графика.
///
/// API отдаёт среду как [wen], в UI используем канонический [wed].
String canonicalScheduleDayKey(String day) {
  switch (day.toLowerCase()) {
    case 'wen':
      return 'wed';
    default:
      return day.toLowerCase();
  }
}

bool scheduleDayKeysMatch(String a, String b) =>
    canonicalScheduleDayKey(a) == canonicalScheduleDayKey(b);

/// 1 = понедельник … 7 = воскресенье ([DateTime.weekday]).
int? scheduleDayKeyToWeekday(String dayKey) {
  switch (canonicalScheduleDayKey(dayKey)) {
    case 'mon':
      return 1;
    case 'tue':
      return 2;
    case 'wed':
      return 3;
    case 'thu':
      return 4;
    case 'fri':
      return 5;
    case 'sat':
      return 6;
    case 'sun':
      return 7;
    default:
      return null;
  }
}
