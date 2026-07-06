class ClientsApiResponse {
  ClientsApiResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ClientsApiResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = (json['results'] as List<dynamic>? ?? const []);
    return ClientsApiResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: rawResults
          .map((e) => ClientItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int count;
  final String? next;
  final String? previous;
  final List<ClientItem> results;
}

class ClientItem {
  ClientItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.status,
    required this.reliabilityFactor,
    required this.balance,
    required this.numberOfVisits,
    required this.discount,
    required this.transactionsSum,
    required this.appointmentSumAvg,
    required this.commentText,
  });

  factory ClientItem.fromJson(Map<String, dynamic> json) {
    return ClientItem(
      id: _readInt(json['id']),
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: _readInt(json['status']),
      reliabilityFactor: _readDouble(json['reliability_factor']),
      balance: _readDouble(json['balance']),
      numberOfVisits: _readInt(json['number_of_visits']),
      discount: _readDouble(json['discount']),
      transactionsSum: _readDouble(json['transactions_sum']),
      appointmentSumAvg: _readDouble(json['appointment_sum_avg']),
      commentText: (json['comment'] as Map<String, dynamic>?)?['text'] as String?,
    );
  }

  static int _readInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim()) ?? 0;
    return 0;
  }

  static double _readDouble(dynamic raw) {
    if (raw is double) return raw;
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      return double.tryParse(raw.trim().replaceAll(',', '.')) ?? 0;
    }
    return 0;
  }

  double get averageCheck {
    if (appointmentSumAvg > 0) return appointmentSumAvg;
    if (numberOfVisits <= 0) return 0;
    return transactionsSum / numberOfVisits;
  }

  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final int status;
  final double reliabilityFactor;
  final double balance;
  final int numberOfVisits;
  final double discount;
  final double transactionsSum;
  final double appointmentSumAvg;
  final String? commentText;
}
