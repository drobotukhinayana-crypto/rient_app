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
  });

  final int id;
  final String datetime;
  final int status;
  final List<AppointmentServiceApi> services;
  final AppointmentWorkerApi? worker;
  final AppointmentClientApi? client;
  final String? commentText;

  /// Записи для отображения в расписании (все известные статусы 0–4).
  bool get isActive => status >= 0 && status <= 4;

  factory AppointmentApi.fromJson(Map<String, dynamic> json) {
    final comment = json['comment'] as Map<String, dynamic>?;
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
      commentText: comment == null ? null : comment['text'] as String?,
    );
  }
}

class AppointmentServiceApi {
  const AppointmentServiceApi({
    required this.name,
    required this.datetime,
    required this.duration,
    required this.addDuration,
  });

  final String? name;
  final String? datetime;
  final int duration;
  final int addDuration;

  int get totalDurationMinutes => duration + addDuration;

  factory AppointmentServiceApi.fromJson(Map<String, dynamic> json) {
    return AppointmentServiceApi(
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
  });

  final int id;
  final String? firstName;
  final String? lastName;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory AppointmentClientApi.fromJson(Map<String, dynamic> json) {
    return AppointmentClientApi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}
