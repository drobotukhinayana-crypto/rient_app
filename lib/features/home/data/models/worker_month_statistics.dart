class WorkerMonthStatistics {
  const WorkerMonthStatistics({
    required this.income,
    required this.occupancy,
    required this.performance,
    required this.clients,
    required this.cancellations,
    required this.payDue,
    this.services = const {},
  });

  final double income;
  final double occupancy;
  final double performance;
  final int clients;
  final int cancellations;
  final double payDue;
  final Map<String, int> services;

  factory WorkerMonthStatistics.fromJson(Map<String, dynamic> json) {
    final services = <String, int>{};
    final rawServices = json['services'];
    if (rawServices is List) {
      for (final item in rawServices.whereType<Map>()) {
        final row = item.map((k, v) => MapEntry(k.toString(), v));
        final name = (row['_name'] ?? row['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        services[name] = (row['count'] as num?)?.toInt() ?? 0;
      }
    }

    return WorkerMonthStatistics(
      income: (json['income'] as num?)?.toDouble() ?? 0,
      occupancy: (json['occupancy'] as num?)?.toDouble() ?? 0,
      performance: (json['performance'] as num?)?.toDouble() ?? 0,
      clients: (json['clients'] as num?)?.toInt() ?? 0,
      cancellations: (json['cancellations'] as num?)?.toInt() ?? 0,
      payDue: (json['pay_due'] as num?)?.toDouble() ?? 0,
      services: services,
    );
  }
}
