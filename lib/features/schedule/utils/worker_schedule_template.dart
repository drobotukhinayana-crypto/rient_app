import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';

/// Шаблон графика сотрудника: те же данные, что для сетки «График работы».
class WorkerScheduleTemplate {
  const WorkerScheduleTemplate({
    required this.patterns,
    this.shiftConfig,
  });

  final List<SchedulePatternItemApi> patterns;
  final Map<String, dynamic>? shiftConfig;
}
