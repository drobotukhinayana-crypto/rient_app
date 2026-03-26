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
  });

  factory ClientItem.fromJson(Map<String, dynamic> json) {
    return ClientItem(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String phone;
}
