const _copyrightHolder = 'TRIOBOT';
const _copyrightStartYear = 2026;

/// «Copyright TRIOBOT 2026» до 2027 года, затем «Copyright TRIOBOT 2026-{текущий год}».
String copyrightNotice({DateTime? now}) {
  final year = (now ?? DateTime.now()).year;
  if (year <= _copyrightStartYear) {
    return 'Copyright $_copyrightHolder $_copyrightStartYear';
  }
  return 'Copyright $_copyrightHolder $_copyrightStartYear-$year';
}
