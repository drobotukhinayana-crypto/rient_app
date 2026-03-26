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
    required this.balance,
    required this.numberOfVisits,
    required this.discount,
    required this.transactionsSum,
  });

  factory ClientItem.fromJson(Map<String, dynamic> json) {
    return ClientItem(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      numberOfVisits: json['number_of_visits'] as int? ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      transactionsSum: (json['transactions_sum'] as num?)?.toDouble() ?? 0,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final int status;
  final double balance;
  final int numberOfVisits;
  final double discount;
  final double transactionsSum;
}
