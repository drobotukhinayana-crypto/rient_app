import 'package:dio/dio.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';

/// Поле для повторного POST/PATCH после подтверждения в диалоге (как на сайте).
const appointmentCreateAnywayField = 'create_anyway';

class AppointmentInventoryConflictException implements Exception {
  AppointmentInventoryConflictException({
    required this.message,
    this.inventoryLabel,
    this.conflictLines = const [],
  });

  final String message;
  final String? inventoryLabel;
  final List<String> conflictLines;

  @override
  String toString() => message;
}

bool isAppointmentInventoryConflictMessage(String? raw) {
  if (raw == null) return false;
  return raw.contains('Инвентарь') &&
      raw.contains('в выбранное время будут использоваться');
}

bool isAppointmentInventoryConflictApiData(dynamic data) {
  if (data == null) return false;
  if (data is String) {
    return isAppointmentInventoryConflictMessage(data);
  }
  if (data is List) {
    for (final item in data) {
      if (isAppointmentInventoryConflictApiData(item)) return true;
    }
    return false;
  }
  if (data is Map) {
    final errors = data['non_field_errors'];
    if (errors is List) {
      for (final item in errors) {
        if (item is String && isAppointmentInventoryConflictMessage(item)) {
          return true;
        }
      }
    }
    for (final value in data.values) {
      if (isAppointmentInventoryConflictApiData(value)) return true;
    }
  }
  return false;
}

String? extractAppointmentInventoryConflictMessage(dynamic data) {
  if (data == null) return null;
  if (data is String && isAppointmentInventoryConflictMessage(data)) {
    return data.trim();
  }
  if (data is List) {
    for (final item in data) {
      final message = extractAppointmentInventoryConflictMessage(item);
      if (message != null) return message;
    }
    return null;
  }
  if (data is Map) {
    final errors = data['non_field_errors'];
    if (errors is List) {
      for (final item in errors) {
        if (item is String && isAppointmentInventoryConflictMessage(item)) {
          return item.trim();
        }
      }
    }
    for (final value in data.values) {
      final message = extractAppointmentInventoryConflictMessage(value);
      if (message != null) return message;
    }
  }
  return null;
}

String? parseInventoryLabelFromMessage(String message) {
  final match = RegExp(r'Инвентарь\s+"([^"]+)"').firstMatch(message);
  return match?.group(1)?.trim();
}

List<String> parseInventoryConflictLines(String message) {
  final lines = <String>[];
  final seen = <String>{};
  for (final rawLine in message.split(RegExp(r'[\r\n]+'))) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    if (line.startsWith('Инвентарь')) continue;
    if (seen.add(line)) lines.add(line);
  }
  return lines;
}

AppointmentInventoryConflictException? appointmentInventoryConflictFromApiData(
  dynamic data,
) {
  final message = extractAppointmentInventoryConflictMessage(data);
  if (message == null) return null;
  return AppointmentInventoryConflictException(
    message: message,
    inventoryLabel: parseInventoryLabelFromMessage(message),
    conflictLines: parseInventoryConflictLines(message),
  );
}

bool isAppointmentInventoryConflictError(Object error) {
  if (error is AppointmentInventoryConflictException) return true;
  if (error is! CustomException) return false;
  final caused = error.causedError;
  if (caused is! DioException) return false;
  return isAppointmentInventoryConflictApiData(caused.response?.data);
}

AppointmentInventoryConflictException? appointmentInventoryConflictFromError(
  Object error,
) {
  if (error is AppointmentInventoryConflictException) return error;
  if (error is! CustomException) return null;
  final caused = error.causedError;
  if (caused is! DioException) return null;
  return appointmentInventoryConflictFromApiData(caused.response?.data);
}

Map<String, dynamic> withInventoryConflictOverride(
  Map<String, dynamic> payload, {
  required bool createAnyway,
}) {
  if (!createAnyway) return payload;
  return {
    ...payload,
    appointmentCreateAnywayField: true,
  };
}
