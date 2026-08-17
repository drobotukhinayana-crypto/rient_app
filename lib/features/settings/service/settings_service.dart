import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref),
);

class SettingsActionException implements Exception {
  SettingsActionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SettingsService {
  SettingsService(this.ref);

  final Ref ref;

  static const _captcha = 'dummy';

  Future<void> resetWorkerAccess({required int workerId}) async {
    final metas = await _loadWorkersMetaMap(hasUserAccountOnly: true);
    final brief = metas[workerId];
    if (brief != null && !brief.hasUserAccount) {
      throw SettingsActionException(
        'У сотрудника нет доступа к программе',
      );
    }
    await _patchWorker(workerId, hasUserAccount: false);
  }

  Future<void> resetWorkersAccess({required List<int> workerIds}) async {
    if (workerIds.isEmpty) {
      throw SettingsActionException('Нет сотрудников для выбранного филиала');
    }

    final metas = await _loadWorkersMetaMap(hasUserAccountOnly: true);
    var resetCount = 0;
    Object? lastError;

    for (final workerId in workerIds) {
      final brief = metas[workerId];
      if (brief != null && !brief.hasUserAccount) continue;
      try {
        await resetWorkerAccess(workerId: workerId);
        resetCount++;
      } catch (e) {
        if (e is SettingsActionException &&
            e.message == 'У сотрудника нет доступа к программе') {
          continue;
        }
        lastError = e;
      }
    }

    if (resetCount > 0) return;
    if (lastError != null) throw lastError;
    throw SettingsActionException(
      'Нет сотрудников с доступом к программе для сброса',
    );
  }

  Future<void> prohibitOnlineBooking({required int workerId}) async {
    final metas = await _loadWorkersMetaMap();
    final brief = metas[workerId];
    if (brief != null && !brief.active) {
      throw SettingsActionException('Онлайн-запись уже запрещена');
    }
    await _patchWorker(workerId, active: false);
  }

  Future<void> prohibitOnlineBookingForWorkers({
    required List<int> workerIds,
  }) async {
    if (workerIds.isEmpty) {
      throw SettingsActionException('Нет сотрудников для выбранного филиала');
    }

    final metas = await _loadWorkersMetaMap();
    var updatedCount = 0;
    Object? lastError;

    for (final workerId in workerIds) {
      final meta = metas[workerId];
      if (meta == null || !meta.active) continue;
      try {
        await prohibitOnlineBooking(workerId: workerId);
        updatedCount++;
      } catch (e) {
        lastError = e;
      }
    }

    if (updatedCount > 0) return;
    if (lastError != null) throw lastError;
    throw SettingsActionException(
      'У выбранных сотрудников онлайн-запись уже запрещена',
    );
  }

  /// Мастера филиала с доступом к приложению (workers-full, has_user_account=1).
  Future<List<WorkerApi>> loadAllBranchWorkersForPicker() async {
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      throw SettingsActionException('Филиал не выбран');
    }
    final rows = await _getWorkersFull(branchId, hasUserAccount: true);
    return _workersFromRows(rows);
  }

  /// Мастера с включённой онлайн-записью — из /workers/.
  Future<List<WorkerApi>> loadActiveBranchWorkersForPicker() async {
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      throw SettingsActionException('Филиал не выбран');
    }
    final rows = await _getWorkers(branchId);
    return _workersFromRows(rows);
  }

  Future<Map<int, _WorkerSettingsMeta>> _loadWorkersMetaMap({
    bool hasUserAccountOnly = false,
  }) async {
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      throw SettingsActionException('Филиал не выбран');
    }

    final rows = await _getWorkersFull(
      branchId,
      hasUserAccount: hasUserAccountOnly ? true : null,
    );
    final onlineBookingActiveIds = await _loadOnlineBookingActiveWorkerIds(
      branchId,
    );
    return {
      for (final row in rows)
        if ((row['id'] as num?)?.toInt() case final int? id when id != null)
          id: _WorkerSettingsMeta(
            hasUserAccount: _readBool(row['has_user_account']),
            active: onlineBookingActiveIds.contains(id),
          ),
    };
  }

  Future<Set<int>> _loadOnlineBookingActiveWorkerIds(int branchId) async {
    final rows = await _getWorkers(branchId);
    return {
      for (final row in rows)
        if ((row['id'] as num?)?.toInt() case final int id) id,
    };
  }

  List<WorkerApi> _workersFromRows(List<Map<String, dynamic>> rows) {
    return [
      for (final row in rows)
        if ((row['id'] as num?)?.toInt() case final int id when id > 0)
          WorkerApi(
            id: id,
            firstName: row['first_name'] as String?,
            lastName: row['last_name'] as String?,
            specialization: row['specialization'] as String?,
            picture: row['picture'] as String?,
            pictureThumbnail: row['picture_thumbnail'] as String?,
          ),
    ];
  }

  Future<List<Map<String, dynamic>>> _getWorkers(int branchId) async {
    final organizationId = ref.read(organizationIdProvider);
    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');

    final response = await _requestMap(
      () => createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'page_size': 500,
          'page': 1,
          'with_services': 1,
          'with_schedules': 1,
        },
        options: Options(headers: _authHeaders()),
      ),
      errorLabel: 'load workers',
    );

    return (response['results'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  Future<List<Map<String, dynamic>>> _getWorkersFull(
    int branchId, {
    bool? hasUserAccount,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers-full/',
    );

    final response = await _requestMap(
      () => createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'ordering': 'last_name,first_name',
          'page_size': 500,
          'page': 1,
          if (hasUserAccount == true) 'has_user_account': 1,
        },
        options: Options(headers: _authHeaders()),
      ),
      errorLabel: 'load workers-full',
    );

    return (response['results'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  Future<void> _patchWorker(
    int workerId, {
    bool? active,
    bool? hasUserAccount,
  }) async {
    final source = await _loadWorkerPatchSource(workerId);
    final organizationId = ref.read(organizationIdProvider);
    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/',
    );

    final body = _workerUpdateBodyFromDetail(
      source,
      active: active ?? _readBool(source['active'], fallback: true),
    );
    if (hasUserAccount != null) {
      body['has_user_account'] = hasUserAccount;
    }

    try {
      await _request(
        () => createAppDio().patch<dynamic>(
          url,
          data: body,
          options: Options(headers: _authHeaders()),
        ),
        errorLabel: 'update worker',
        allowedCodes: {200, 201, 204},
      );
    } on CustomException catch (e) {
      throw _toSettingsActionException(e.causedError);
    }
  }

  Future<Map<String, dynamic>> _loadWorkerPatchSource(int workerId) async {
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      throw SettingsActionException('Филиал не выбран');
    }

    final row = await _findWorkerRow(workerId, branchId);
    if (row == null) {
      throw SettingsActionException('Не удалось загрузить данные сотрудника');
    }

    final detail = await _tryGetWorkerDetail(workerId);
    if (detail == null) return row;

    return {...row, ...detail};
  }

  Future<Map<String, dynamic>?> _findWorkerRow(
    int workerId,
    int branchId,
  ) async {
    for (final row in await _getWorkers(branchId)) {
      if ((row['id'] as num?)?.toInt() == workerId) return row;
    }
    for (final row in await _getWorkersFull(branchId)) {
      if ((row['id'] as num?)?.toInt() == workerId) return row;
    }
    return null;
  }

  Future<Map<String, dynamic>?> _tryGetWorkerDetail(int workerId) async {
    final organizationId = ref.read(organizationIdProvider);
    final branchId = ref.read(currentBranchIdProvider);
    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/',
    );

    final queryVariants = <Map<String, dynamic>?>[
      if (branchId > 0) {'branch': branchId},
      null,
    ];

    for (final query in queryVariants) {
      try {
        return await _requestMap(
          () => createAppDio().get<Map<String, dynamic>>(
            url,
            queryParameters: query,
            options: Options(headers: _authHeaders()),
          ),
          errorLabel: 'load worker',
        );
      } catch (_) {}
    }
    return null;
  }

  Map<String, dynamic> _workerUpdateBodyFromDetail(
    Map<String, dynamic> detail, {
    required bool active,
  }) {
    final body = <String, dynamic>{
      'captcha': _captcha,
      'active': active,
      'first_name': detail['first_name'],
      'last_name': detail['last_name'],
    };

    final branches = (detail['branches'] as List<dynamic>? ?? const [])
        .map((value) => (value as num).toInt())
        .toList();
    if (branches.isNotEmpty) {
      body['branches'] = branches;
    }

    for (final key in const [
      'specialization',
      'time_start',
      'time_end',
      'schedule_shift_pattern',
      'schedule_shift_start_date',
      'email',
    ]) {
      final value = detail[key];
      if (value != null) body[key] = value;
    }

    for (final key in const ['schedule_type', 'salary_percent']) {
      final value = detail[key];
      if (value is num) body[key] = value.toInt();
    }

    for (final key in const [
      'notify_on_new_appointment',
      'show_full_number_in_notifications',
      'has_user_account',
      'see_contact_data',
      'delete_schedule',
      'transfer_schedule',
      'create_schedule',
      'see_income',
      'see_to_be_paid',
      'change',
      'change_worker',
      'change_status',
    ]) {
      if (detail.containsKey(key)) {
        body[key] = _readBool(detail[key]);
      }
    }

    return body;
  }

  bool _readBool(dynamic raw, {bool fallback = false}) {
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    if (raw is String) {
      final value = raw.trim().toLowerCase();
      if (value == 'true' || value == '1') return true;
      if (value == 'false' || value == '0') return false;
    }
    return fallback;
  }

  String? _settingsErrorMessage(Object? error) {
    if (error is! DioException) return null;

    final statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      return 'Сотрудник не найден';
    }
    if (statusCode == 403) {
      return 'Недостаточно прав для этого действия';
    }

    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final parts = <String>[];
      for (final entry in data.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          parts.add('${entry.key}: ${value.first}');
        } else if (value is String && value.isNotEmpty) {
          parts.add(value);
        }
      }
      if (parts.isNotEmpty) return parts.join('\n');
    }
    if (data is String && data.isNotEmpty) {
      return _sanitizeServerMessage(data);
    }
    return null;
  }

  String _sanitizeServerMessage(String raw) {
    final trimmed = raw.trim();
    if (trimmed.contains('<!DOCTYPE html>') ||
        trimmed.contains('<html') ||
        trimmed.contains('FileNotFoundError at')) {
      return 'Не удалось выполнить действие. Попробуйте позже.';
    }
    return trimmed;
  }

  SettingsActionException _toSettingsActionException(Object? error) {
    if (error is SettingsActionException) return error;
    final message = _settingsErrorMessage(error);
    if (message != null) {
      return SettingsActionException(message);
    }
    return SettingsActionException(
      'Не удалось выполнить действие. Попробуйте позже.',
    );
  }

  Map<String, String> _authHeaders() {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }
    return {
      'Authorization': 'JWT $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _request(
    Future<Response<dynamic>> Function() call, {
    required String errorLabel,
    Set<int>? allowedCodes,
  }) async {
    final codes = allowedCodes ?? {200};
    try {
      final response = await call();
      final code = response.statusCode ?? 0;
      if (codes.contains(code)) {
        return;
      }
      throw CustomException(
        causedError: Exception('Failed to $errorLabel: $code'),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      if (e is CustomException) rethrow;
      throw CustomException(causedError: e);
    }
  }

  Future<Map<String, dynamic>> _requestMap(
    Future<Response<Map<String, dynamic>>> Function() call, {
    required String errorLabel,
  }) async {
    try {
      final response = await call();
      final code = response.statusCode ?? 0;
      if (code == 200 && response.data != null) {
        return response.data!;
      }
      throw CustomException(
        causedError: Exception('Failed to $errorLabel: $code'),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      if (e is CustomException) rethrow;
      throw CustomException(causedError: e);
    }
  }
}

class _WorkerSettingsMeta {
  const _WorkerSettingsMeta({
    required this.hasUserAccount,
    required this.active,
  });

  final bool hasUserAccount;
  final bool active;
}
