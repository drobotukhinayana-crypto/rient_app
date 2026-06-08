/// Источник записи из API (`appointment.source`).
class AppointmentSourceInfo {
  const AppointmentSourceInfo({
    required this.label,
    required this.assetPath,
    required this.isSvg,
  });

  final String label;
  final String assetPath;
  final bool isSvg;
}

AppointmentSourceInfo? appointmentSourceInfo(int? source) {
  if (source == null) return null;
  return switch (source) {
    0 => const AppointmentSourceInfo(
      label: 'Сотрудник',
      assetPath: 'assets/sotrudnik.svg',
      isSvg: true,
    ),
    1 => const AppointmentSourceInfo(
      label: 'Виджет на сайте',
      assetPath: 'assets/vidget_na_sait.svg',
      isSvg: true,
    ),
    3 => const AppointmentSourceInfo(
      label: 'Прямая ссылка',
      assetPath: 'assets/prymai_silka.svg',
      isSvg: true,
    ),
    4 => const AppointmentSourceInfo(
      label: 'VK',
      assetPath: 'assets/vk_source.svg',
      isSvg: true,
    ),
    -2 => const AppointmentSourceInfo(
      label: 'Яндекс',
      assetPath: 'assets/yandex_source.svg',
      isSvg: true,
    ),
    -5 => const AppointmentSourceInfo(
      label: '2GIS',
      assetPath: 'assets/2gis.png',
      isSvg: false,
    ),
    _ => null,
  };
}
