class WorkerServicesApiResponse {
  WorkerServicesApiResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory WorkerServicesApiResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = (json['results'] as List<dynamic>? ?? const []);
    return WorkerServicesApiResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: rawResults
          .map((e) => WorkerServiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int count;
  final String? next;
  final String? previous;
  final List<WorkerServiceItem> results;
}

class WorkerServiceItem {
  WorkerServiceItem({
    required this.id,
    required this.branch,
    required this.worker,
    required this.price,
    required this.duration,
    required this.addDuration,
    required this.service,
  });

  factory WorkerServiceItem.fromJson(Map<String, dynamic> json) {
    return WorkerServiceItem(
      id: json['id'] as int? ?? 0,
      branch: json['branch'] as int? ?? 0,
      worker: json['worker'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] as int? ?? 0,
      addDuration:
          (json['add_duration'] as num?)?.toInt() ??
          ((json['service'] as Map<String, dynamic>?)?['add_duration'] as num?)
                  ?.toInt() ??
          0,
      service: WorkerServiceInfo.fromJson(
        json['service'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final int id;
  final int branch;
  final int worker;
  final double price;
  final int duration;
  final int addDuration;
  final WorkerServiceInfo service;

  int get totalDurationMinutes => duration + addDuration;
}

class WorkerServiceInfo {
  WorkerServiceInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  factory WorkerServiceInfo.fromJson(Map<String, dynamic> json) {
    return WorkerServiceInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] as int? ?? 0,
    );
  }

  final int id;
  final String name;
  final double price;
  final int duration;
}
