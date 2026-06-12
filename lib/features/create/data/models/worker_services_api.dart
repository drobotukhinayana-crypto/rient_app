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
    this.hasInventory = false,
  });

  factory WorkerServiceInfo.fromJson(Map<String, dynamic> json) {
    final catalog = _catalogServiceJson(json);
    final source = catalog ?? json;

    return WorkerServiceInfo(
      id: (source['id'] as num?)?.toInt() ?? (json['id'] as num?)?.toInt() ?? 0,
      name: (source['name'] as String?) ?? json['name'] as String? ?? '',
      price: (source['price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0,
      duration: (source['duration'] as num?)?.toInt() ??
          (json['duration'] as num?)?.toInt() ??
          0,
      hasInventory: parseHasInventory(
        source['has_inventory'] ?? json['has_inventory'],
      ),
    );
  }

  /// API: `has_inventory` — bool или число (>0 значит есть инвентарь).
  static bool parseHasInventory(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    return false;
  }

  static Map<String, dynamic>? _catalogServiceJson(Map<String, dynamic> json) {
    final nested = json['service'];
    if (nested is Map<String, dynamic>) return nested;
    if (nested is Map) {
      return nested.map((k, v) => MapEntry(k.toString(), v));
    }
    return null;
  }

  final int id;
  final String name;
  final double price;
  final int duration;
  final bool hasInventory;
}
