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
