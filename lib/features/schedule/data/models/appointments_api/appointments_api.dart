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
) {
  return appointments
      .where((a) => a.isActive)
      .where((a) => a.overlapsScheduleInstantRange(dateTimeGte, dateTimeLte))
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

  /// Записи для отображения в расписании (все известные статусы 0–4).
  bool get isActive => status >= 0 && status <= 4;

  /// Показывать иконку комментария только при непустом `comment.text`.
  bool get hasComment => (commentText?.trim().isNotEmpty ?? false);

  /// Время для календаря: сначала по услугам, иначе корневой `datetime`.
  DateTime? get schedulePrimaryDateTimeLocal {
    for (final service in services) {
      final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
      if (parsed != null) return parsed;
    }
    return DateTime.tryParse(datetime)?.toLocal();
  }

  /// Календарный день записи по услугам (не дата создания).
  DateTime appointmentCalendarDayLocal() {
    DateTime? earliestDay;
    for (final service in services) {
      final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (earliestDay == null || day.isBefore(earliestDay)) {
        earliestDay = day;
      }
    }
    if (earliestDay != null) return earliestDay;
    final primary = schedulePrimaryDateTimeLocal;
    if (primary != null) {
      return DateTime(primary.year, primary.month, primary.day);
    }
    final root = DateTime.tryParse(datetime)?.toLocal() ?? DateTime.now();
    return DateTime(root.year, root.month, root.day);
  }

  /// Начало услуги: `services[].datetime`, иначе время на [appointmentCalendarDayLocal].
  DateTime resolveServiceStartLocal(AppointmentServiceApi service) {
    final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
    if (parsed != null) return parsed;

    final calendarDay = appointmentCalendarDayLocal();
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

    final root = DateTime.tryParse(datetime)?.toLocal();
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

  DateTime resolveServiceEndLocal(AppointmentServiceApi service) {
    final start = resolveServiceStartLocal(service);
    final duration =
        service.totalDurationMinutes <= 0 ? 30 : service.totalDurationMinutes;
    return start.add(Duration(minutes: duration));
  }

  /// Общий интервал записи: от начала первой до конца последней услуги.
  ({DateTime start, DateTime end}) mergedScheduleRangeLocal() {
    if (services.isEmpty) {
      final start = DateTime.tryParse(datetime)?.toLocal() ?? DateTime.now();
      return (start: start, end: start.add(const Duration(minutes: 30)));
    }
    var minStart = resolveServiceStartLocal(services.first);
    var maxEnd = resolveServiceEndLocal(services.first);
    for (final service in services.skip(1)) {
      final start = resolveServiceStartLocal(service);
      final end = resolveServiceEndLocal(service);
      if (start.isBefore(minStart)) minStart = start;
      if (end.isAfter(maxEnd)) maxEnd = end;
    }
    return (start: minStart, end: maxEnd);
  }

  /// Попадает ли запись в диапазон календарных дней [rangeStart, rangeEnd].
  bool overlapsScheduleDateRange(DateTime rangeStart, DateTime rangeEnd) {
    final startDay = DateTime(
      rangeStart.year,
      rangeStart.month,
      rangeStart.day,
    );
    final endDay = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    for (final service in services) {
      final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (!day.isBefore(startDay) && !day.isAfter(endDay)) return true;
    }
    final primary = schedulePrimaryDateTimeLocal;
    if (primary == null) return false;
    final day = DateTime(primary.year, primary.month, primary.day);
    return !day.isBefore(startDay) && !day.isAfter(endDay);
  }

  /// Попадает ли запись в интервал моментов времени [gte, lte].
  bool overlapsScheduleInstantRange(DateTime gte, DateTime lte) {
    for (final service in services) {
      final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
      if (parsed != null && !parsed.isBefore(gte) && !parsed.isAfter(lte)) {
        return true;
      }
    }
    final primary = schedulePrimaryDateTimeLocal;
    if (primary == null) return false;
    return !primary.isBefore(gte) && !primary.isAfter(lte);
  }

  factory AppointmentApi.fromJson(Map<String, dynamic> json) {
    final comment = json['comment'] as Map<String, dynamic>?;
    final rawText = comment?['text'];
    final commentText = rawText == null ? null : rawText.toString();
    final commentId = (comment?['id'] as num?)?.toInt();
    return AppointmentApi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      datetime: (json['datetime'] ?? '').toString(),
      status: (json['status'] as num?)?.toInt() ?? -1,
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => AppointmentServiceApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      worker: json['worker'] == null
          ? null
          : AppointmentWorkerApi.fromJson(json['worker'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : AppointmentClientApi.fromJson(json['client'] as Map<String, dynamic>),
      commentText: commentText,
      commentId: commentId,
    );
  }
}

class AppointmentServiceApi {
  const AppointmentServiceApi({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.datetime,
    required this.duration,
    required this.addDuration,
  });

  final int? id;
  final int? serviceId;
  final String? name;
  final String? datetime;
  final int duration;
  final int addDuration;

  int get totalDurationMinutes => duration + addDuration;

  factory AppointmentServiceApi.fromJson(Map<String, dynamic> json) {
    final rawService = json['service'];
    int? parsedServiceId;
    if (rawService is num) {
      parsedServiceId = rawService.toInt();
    } else if (rawService is Map<String, dynamic>) {
      parsedServiceId = (rawService['id'] as num?)?.toInt();
    }
    return AppointmentServiceApi(
      id: (json['id'] as num?)?.toInt(),
      serviceId: parsedServiceId,
      name: json['name'] as String?,
      datetime: json['datetime'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      addDuration: (json['add_duration'] as num?)?.toInt() ?? 0,
    );
  }
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
