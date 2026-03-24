class AvailableWorkerShift {
  const AvailableWorkerShift({
    required this.timeStart,
    required this.timeEnd,
    required this.breakStart,
    required this.breakEnd,
    required this.worker,
  });

  final String timeStart;
  final String timeEnd;
  final String? breakStart;
  final String? breakEnd;
  final AvailableWorker worker;

  factory AvailableWorkerShift.fromJson(Map<String, dynamic> json) {
    return AvailableWorkerShift(
      timeStart: (json['time_start'] ?? '').toString(),
      timeEnd: (json['time_end'] ?? '').toString(),
      breakStart: json['break_start'] as String?,
      breakEnd: json['break_end'] as String?,
      worker: AvailableWorker.fromJson(json['worker'] as Map<String, dynamic>),
    );
  }
}

class AvailableWorker {
  const AvailableWorker({
    required this.id,
    required this.specialization,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
  });

  final int id;
  final String? specialization;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;

  factory AvailableWorker.fromJson(Map<String, dynamic> json) {
    return AvailableWorker(
      id: (json['id'] as num).toInt(),
      specialization: json['specialization'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      middleName: json['middle_name'] as String?,
      email: json['email'] as String?,
    );
  }
}
