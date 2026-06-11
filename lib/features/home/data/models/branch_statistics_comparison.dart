/// Ответ `GET .../branches/{id}/statistics/?type=month` (как на сайте).
class BranchStatisticsComparison {
  const BranchStatisticsComparison({
    required this.current,
    this.previous,
  });

  final BranchStatisticsPeriod current;
  final BranchStatisticsPeriod? previous;

  factory BranchStatisticsComparison.fromJson(Map<String, dynamic> json) {
    final currentRaw = json['current'];
    if (currentRaw is! Map) {
      throw FormatException('Branch statistics: missing current');
    }
    final previousRaw = json['previous'];
    return BranchStatisticsComparison(
      current: BranchStatisticsPeriod.fromJson(
        Map<String, dynamic>.from(currentRaw),
      ),
      previous: previousRaw is Map
          ? BranchStatisticsPeriod.fromJson(
              Map<String, dynamic>.from(previousRaw),
            )
          : null,
    );
  }
}

class BranchStatisticsPeriod {
  const BranchStatisticsPeriod({
    this.totalIncome,
    this.occupancy,
    this.averageTransactions,
    this.totalClients,
    this.newClients,
    this.existingClients,
    this.oneshotClients,
    this.oneshotClientsAll,
    this.totalAppointments,
    this.completedAppointments,
    this.canceledAppointments,
    this.incomeByDay = const [],
  });

  final double? totalIncome;
  final double? occupancy;
  final double? averageTransactions;
  final int? totalClients;
  final int? newClients;
  final int? existingClients;
  final int? oneshotClients;
  final int? oneshotClientsAll;
  final int? totalAppointments;
  final int? completedAppointments;
  final int? canceledAppointments;
  final List<BranchStatisticsIncomeDay> incomeByDay;

  factory BranchStatisticsPeriod.fromJson(Map<String, dynamic> json) {
    final incomeRaw = json['income_by_day'];
    final incomeByDay = <BranchStatisticsIncomeDay>[];
    if (incomeRaw is List) {
      for (final item in incomeRaw.whereType<Map>()) {
        final row = item.map((k, v) => MapEntry(k.toString(), v));
        incomeByDay.add(
          BranchStatisticsIncomeDay(
            date: row['date']?.toString() ?? '',
            income: ((row['income'] ?? row['sum']) as num?)?.toDouble() ?? 0,
            payDue: (row['pay_due'] as num?)?.toDouble(),
          ),
        );
      }
    }

    return BranchStatisticsPeriod(
      totalIncome: (json['total_income'] as num?)?.toDouble(),
      occupancy: (json['occupancy'] as num?)?.toDouble(),
      averageTransactions: (json['average_transactions'] as num?)?.toDouble(),
      totalClients: (json['total_clients'] as num?)?.toInt(),
      newClients: (json['new_clients'] as num?)?.toInt(),
      existingClients: (json['existing_clients'] as num?)?.toInt(),
      oneshotClients: (json['oneshot_clients'] as num?)?.toInt(),
      oneshotClientsAll: (json['oneshot_clients_all'] as num?)?.toInt(),
      totalAppointments: (json['total_appointments'] as num?)?.toInt(),
      completedAppointments: (json['completed_appointments'] as num?)?.toInt(),
      canceledAppointments:
          ((json['canceled_appointments'] ?? json['cancelled_appointments'])
                  as num?)
              ?.toInt(),
      incomeByDay: incomeByDay,
    );
  }
}

class BranchStatisticsIncomeDay {
  const BranchStatisticsIncomeDay({
    required this.date,
    required this.income,
    this.payDue,
  });

  final String date;
  final double income;
  final double? payDue;
}
