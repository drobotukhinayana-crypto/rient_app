/// Склонения названия сущности «сотрудник» из `organization.worker_name` (accounts/).
class WorkerEntityLabels {
  const WorkerEntityLabels({
    required this.name,
    required this.name1,
    required this.name2,
    required this.name3,
    required this.name4,
    required this.name5,
    required this.name6,
    required this.name7,
  });

  /// Именительный: «Специалист», «Мастер».
  final String name;

  /// Родительный ед.: «специалиста» — «Выбрать специалиста».
  final String name1;

  final String name2;
  final String name3;

  /// Именительный мн.: «специалисты» — «Все специалисты».
  final String name4;

  final String name5;
  final String name6;

  /// Родительный мн.: «специалистов» — «Загрузка специалистов…».
  final String name7;

  static const defaults = WorkerEntityLabels(
    name: 'Специалист',
    name1: 'специалиста',
    name2: 'специалиста',
    name3: 'к этому специалисту',
    name4: 'специалисты',
    name5: 'специалисту',
    name6: 'специалиста',
    name7: 'специалистов',
  );

  factory WorkerEntityLabels.fromJson(Map<String, dynamic>? json) {
    if (json == null) return defaults;

    String pick(String key, String fallback) {
      final raw = json[key]?.toString().trim();
      if (raw == null || raw.isEmpty) return fallback;
      return raw;
    }

    final name = pick('name', defaults.name);
    return WorkerEntityLabels(
      name: name,
      name1: pick('name1', defaults.name1),
      name2: pick('name2', defaults.name2),
      name3: pick('name3', defaults.name3),
      name4: pick('name4', defaults.name4),
      name5: pick('name5', defaults.name5),
      name6: pick('name6', defaults.name6),
      name7: pick('name7', defaults.name7),
    );
  }

  String get titleSelect => 'Выбрать $name1';

  String get hintSelect => 'Выберите $name1';

  String get sectionAndServices => '$name и услуги';

  String get allWorkers => 'Все $name4';

  String get notFound => '$name не найден';

  String get loadingWorkers => 'Загрузка $name7...';

  String get matchingWorkersByService => 'Подбор $name7 по услуге…';

  String get searchByWorker => 'Поиск по $name7';

  String get selectWorkerFirst => 'Сначала выберите $name1';

  String get scheduleOfWorker => 'График $name1';

  String workScheduleTitle({required bool isWorkerRole}) =>
      isWorkerRole ? 'График $name1' : 'График работы';

  /// Подпись поля в карточке записи: у воркера — ед.ч., у остальных — мн.ч.
  String workerFieldLabel({required bool isWorkerRole}) =>
      isWorkerRole ? name : name4;

  String get failedLoadWorkersList => 'Не удалось загрузить список $name7';

  String personDisplayName(String fullName) {
    final trimmed = fullName.trim();
    return trimmed.isEmpty ? name : trimmed;
  }
}
