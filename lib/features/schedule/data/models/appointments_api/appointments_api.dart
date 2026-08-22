import 'package:rient_app/core/utils/branch_timezone.dart';
import 'package:rient_app/features/schedule/utils/appointment_source.dart';

/// Расширяет диапазон запроса до границ месяцев: API фильтрует по
/// `appointment.datetime`, а календарь — по `services[].datetime`.
({DateTime gte, DateTime lte}) expandAppointmentsFetchRange(
  DateTime dateTimeGte,
  DateTime dateTimeLte,
) {
  final gte = DateTime(dateTimeGte.year, dateTimeGte.month, 1);
  final lte = DateTime(
    dateTimeLte.year,
    dateTimeLte.month + 1,
    0,
    23,
    59,
    59,
    999,
  );
  return (gte: gte, lte: lte);
}

List<AppointmentApi> filterActiveAppointmentsForVisibleRange(
  Iterable<AppointmentApi> appointments,
  DateTime dateTimeGte,
  DateTime dateTimeLte,
  BranchTimezone branchTz,
) {
  return appointments
      .where((a) => a.isActive)
      .where(
        (a) => a.overlapsScheduleInstantRange(
          dateTimeGte,
          dateTimeLte,
          branchTz,
        ),
      )
      .toList();
}

class AppointmentsApiResponse {
  const AppointmentsApiResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<AppointmentApi> results;

  factory AppointmentsApiResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentsApiResponse(
      count: (json['count'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>? ?? const [])
          .map((e) => AppointmentApi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Статус «Клиент пришел» в ответе API `/appointments/`.
const int appointmentStatusClientArrived = 2;

class AppointmentApi {
  const AppointmentApi({
    required this.id,
    required this.datetime,
    required this.status,
    required this.services,
    required this.worker,
    required this.client,
    required this.commentText,
    required this.commentId,
    this.source,
    this.paid = false,
  });

  final int id;
  final String datetime;
  final int status;
  final List<AppointmentServiceApi> services;
  final AppointmentWorkerApi? worker;
  final AppointmentClientApi? client;
  /// Текст из `comment.text`.
  final String? commentText;
  /// `comment.id`, если блок комментария есть в ответе.
  final int? commentId;
  /// Источник записи из API (0 — сотрудник, 1 — виджет, 3 — ссылка и т.д.).
  final int? source;

  /// Запись оплачена (`paid` в `/appointments/`).
  final bool paid;

  /// Клиент пришёл, но оплата ещё не проведена — жёлтая полоса в расписании.
  bool get isUnpaidClientArrived =>
      status == appointmentStatusClientArrived && !paid;

  /// Есть ли у любой услуги записи привязанный инвентарь.
  bool get hasServiceInventory =>
      services.any((service) => service.hasInventory);

  String? get sourceDisplayLabel => appointmentSourceInfo(source)?.label;

  bool get hasKnownSource => appointmentSourceInfo(source) != null;

  /// Записи для отображения в расписании (все известные статусы 0–4).
  bool get isActive => status >= 0 && status <= 4;

  /// Показывать иконку комментария только при непустом `comment.text`.
  bool get hasComment => (commentText?.trim().isNotEmpty ?? false);

  /// Время для календаря: сначала по услугам, иначе корневой `datetime`.
  DateTime? schedulePrimaryDateTime(BranchTimezone branchTz) {
    for (final service in services) {
      final parsed = branchTz.parseApiDateTime(service.datetime);
      if (parsed != null) return parsed;
    }
    return branchTz.parseApiDateTime(datetime);
  }

  /// Календарный день записи по услугам (не дата создания).
  DateTime appointmentCalendarDay(BranchTimezone branchTz) {
    DateTime? earliestDay;
    for (final service in services) {
      final parsed = branchTz.parseApiDateTime(service.datetime);
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (earliestDay == null || day.isBefore(earliestDay)) {
        earliestDay = day;
      }
    }
    if (earliestDay != null) return earliestDay;
    final primary = schedulePrimaryDateTime(branchTz);
    if (primary != null) {
      return DateTime(primary.year, primary.month, primary.day);
    }
    final root = branchTz.parseApiDateTime(datetime) ?? branchTz.todayDateOnly();
    return DateTime(root.year, root.month, root.day);
  }

  /// Начало услуги: `services[].datetime`, иначе время на [appointmentCalendarDay].
  DateTime resolveServiceStart(AppointmentServiceApi service, BranchTimezone branchTz) {
    final parsed = branchTz.parseApiDateTime(service.datetime);
    if (parsed != null) return parsed;

    final calendarDay = appointmentCalendarDay(branchTz);
    final raw = service.datetime?.trim();
    if (raw != null &&
        raw.isNotEmpty &&
        !raw.contains('T') &&
        !raw.contains('-')) {
      final parts = raw.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          return DateTime(
            calendarDay.year,
            calendarDay.month,
            calendarDay.day,
            h,
            m,
          );
        }
      }
    }

    final root = branchTz.parseApiDateTime(datetime);
    if (root != null) {
      return DateTime(
        calendarDay.year,
        calendarDay.month,
        calendarDay.day,
        root.hour,
        root.minute,
        root.second,
      );
    }
    return calendarDay;
  }

  DateTime resolveServiceEnd(AppointmentServiceApi service, BranchTimezone branchTz) {
    final start = resolveServiceStart(service, branchTz);
    final duration =
        service.totalDurationMinutes <= 0 ? 30 : service.totalDurationMinutes;
    return start.add(Duration(minutes: duration));
  }

  /// Общий интервал записи: от начала первой до конца последней услуги.
  ({DateTime start, DateTime end}) mergedScheduleRange(BranchTimezone branchTz) {
    if (services.isEmpty) {
      final start = branchTz.parseApiDateTime(datetime) ?? branchTz.todayDateOnly();
      return (start: start, end: start.add(const Duration(minutes: 30)));
    }
    var minStart = resolveServiceStart(services.first, branchTz);
    var maxEnd = resolveServiceEnd(services.first, branchTz);
    for (final service in services.skip(1)) {
      final start = resolveServiceStart(service, branchTz);
      final end = resolveServiceEnd(service, branchTz);
      if (start.isBefore(minStart)) minStart = start;
      if (end.isAfter(maxEnd)) maxEnd = end;
    }
    return (start: minStart, end: maxEnd);
  }

  /// Попадает ли запись в диапазон календарных дней [rangeStart, rangeEnd].
  bool overlapsScheduleDateRange(
    DateTime rangeStart,
    DateTime rangeEnd,
    BranchTimezone branchTz,
  ) {
    final startDay = DateTime(
      rangeStart.year,
      rangeStart.month,
      rangeStart.day,
    );
    final endDay = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    for (final service in services) {
      final parsed = branchTz.parseApiDateTime(service.datetime);
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (!day.isBefore(startDay) && !day.isAfter(endDay)) return true;
    }
    final primary = schedulePrimaryDateTime(branchTz);
    if (primary == null) return false;
    final day = DateTime(primary.year, primary.month, primary.day);
    return !day.isBefore(startDay) && !day.isAfter(endDay);
  }

  /// Попадает ли запись в интервал моментов времени [gte, lte].
  bool overlapsScheduleInstantRange(
    DateTime gte,
    DateTime lte,
    BranchTimezone branchTz,
  ) {
    for (final service in services) {
      final parsed = branchTz.parseApiDateTime(service.datetime);
      if (parsed != null && !parsed.isBefore(gte) && !parsed.isAfter(lte)) {
        return true;
      }
    }
    final primary = schedulePrimaryDateTime(branchTz);
    if (primary == null) return false;
    return !primary.isBefore(gte) && !primary.isAfter(lte);
  }

  factory AppointmentApi.fromJson(Map<String, dynamic> json) {
    final comment = json['comment'] as Map<String, dynamic>?;
    final rawText = comment?['text'];
    final commentText = rawText == null ? null : rawText.toString();
    final commentId = (comment?['id'] as num?)?.toInt();
    final services = (json['services'] as List<dynamic>? ?? const [])
        .map((e) => AppointmentServiceApi.fromJson(e as Map<String, dynamic>))
        .toList();
    sortAppointmentServicesByDatetime(services);
    return AppointmentApi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      datetime: (json['datetime'] ?? '').toString(),
      status: (json['status'] as num?)?.toInt() ?? -1,
      services: services,
      worker: json['worker'] == null
          ? null
          : AppointmentWorkerApi.fromJson(json['worker'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : AppointmentClientApi.fromJson(json['client'] as Map<String, dynamic>),
      commentText: commentText,
      commentId: commentId,
      source: (json['source'] as num?)?.toInt(),
      paid: json['paid'] as bool? ?? false,
    );
  }
}

/// Сортирует услуги записи по времени начала (раньше → выше в карточке).
void sortAppointmentServicesByDatetime(List<AppointmentServiceApi> services) {
  services.sort((a, b) {
    final aDt = DateTime.tryParse(a.datetime ?? '');
    final bDt = DateTime.tryParse(b.datetime ?? '');
    if (aDt == null && bDt == null) return 0;
    if (aDt == null) return 1;
    if (bDt == null) return -1;
    final byTime = aDt.compareTo(bDt);
    if (byTime != 0) return byTime;
    final aId = a.id ?? 0;
    final bId = b.id ?? 0;
    return aId.compareTo(bId);
  });
}

class AppointmentServiceApi {
  const AppointmentServiceApi({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.datetime,
    required this.duration,
    required this.addDuration,
    this.hasInventory = false,
  });

  final int? id;
  final int? serviceId;
  final String? name;
  final String? datetime;
  final int duration;
  final int addDuration;
  final bool hasInventory;

  int get totalDurationMinutes => duration + addDuration;

  factory AppointmentServiceApi.fromJson(Map<String, dynamic> json) {
    final rawService = json['service'];
    int? parsedServiceId;
    var hasInventory = false;
    if (rawService is num) {
      // Обычно id привязки услуги мастера (worker-service), реже catalog id.
      parsedServiceId = rawService.toInt();
    } else if (rawService is Map) {
      final map = rawService is Map<String, dynamic>
          ? rawService
          : rawService.map((k, v) => MapEntry(k.toString(), v));
      hasInventory = _parseServiceHasInventory(map);
      final nested = map['service'];
      if (nested is Map) {
        // Обёртка worker-service: внешний id — привязка, вложенный — каталог.
        // Для синхронизации в карточке нужен именно id привязки.
        parsedServiceId = (map['id'] as num?)?.toInt();
      } else {
        parsedServiceId = (map['id'] as num?)?.toInt();
      }
    }
    return AppointmentServiceApi(
      id: (json['id'] as num?)?.toInt(),
      serviceId: parsedServiceId,
      name: json['name'] as String?,
      datetime: json['datetime'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      addDuration: (json['add_duration'] as num?)?.toInt() ?? 0,
      hasInventory: hasInventory,
    );
  }
}

bool _parseServiceHasInventory(Map<String, dynamic> serviceWrapper) {
  final nested = serviceWrapper['service'];
  if (nested is Map<String, dynamic>) {
    return _parseHasInventoryFlag(nested['has_inventory']);
  }
  if (nested is Map) {
    return _parseHasInventoryFlag(nested['has_inventory']);
  }
  return _parseHasInventoryFlag(serviceWrapper['has_inventory']);
}

bool _parseHasInventoryFlag(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is num) return value != 0;
  return false;
}

class AppointmentWorkerApi {
  const AppointmentWorkerApi({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final int id;
  final String? firstName;
  final String? lastName;

  factory AppointmentWorkerApi.fromJson(Map<String, dynamic> json) {
    return AppointmentWorkerApi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}

class AppointmentClientApi {
  const AppointmentClientApi({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  final int id;
  final String? firstName;
  final String? lastName;
  final String? phone;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory AppointmentClientApi.fromJson(Map<String, dynamic> json) {
    return AppointmentClientApi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
    );
  }
}
