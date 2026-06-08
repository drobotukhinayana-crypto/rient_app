import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/change_time_picker_dialog.dart';
import 'package:rient_app/core/widgets/custom_switch_widget.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/utils/work_schedule_appointment_conflict.dart'
    show
        humanizeScheduleApiError,
        isScheduleAppointmentConflictError,
        isWorkSchedulePermissionError,
        workScheduleNoPermissionMessage;
import 'package:rient_app/features/schedule/service/worker_schedule_configs_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:dio/dio.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_loader.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_provider.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';

class SpecialistSchedulePageArgs {
  const SpecialistSchedulePageArgs({
    required this.employeeId,
    required this.employeeName,
    this.pictureUrl,
  });

  final String employeeId;
  final String employeeName;
  final String? pictureUrl;
}

class SpecialistSchedulePage extends ConsumerStatefulWidget {
  const SpecialistSchedulePage({super.key, required this.args});

  final SpecialistSchedulePageArgs args;

  static const name = 'specialist_schedule_page';
  static const path = 'specialist_schedule';

  @override
  ConsumerState<SpecialistSchedulePage> createState() =>
      _SpecialistSchedulePageState();
}

class _SpecialistSchedulePageState extends ConsumerState<SpecialistSchedulePage> {
  static const _scheduleTypes = ['Неделя', 'Смена'];
  static const _defaultGroupStart = '09:00';
  static const _defaultGroupEnd = '20:00';

  String _scheduleType = _scheduleTypes.first;
  bool _weekdaysExpanded = true;
  bool _weekendsExpanded = true;
  bool _formInitialized = false;
  bool _isSaving = false;

  late String _weekdayGroupStart;
  late String _weekdayGroupEnd;
  late List<SpecialistDayDraft> _weekdays;

  late String _weekendGroupStart;
  late String _weekendGroupEnd;
  late List<SpecialistDayDraft> _weekends;

  late final TextEditingController _workDaysController;
  late final TextEditingController _offDaysController;
  DateTime? _shiftStartDate;
  String _shiftWorkStart = _defaultGroupStart;
  String _shiftWorkEnd = _defaultGroupEnd;
  String? _configUuid;
  List<SchedulePatternItemApi> _loadedPatterns = const [];
  List<SpecialistDayDraft> _lastSavedWeekdays = const [];
  List<SpecialistDayDraft> _lastSavedWeekends = const [];
  String _lastSavedWeekdayGroupStart = _defaultGroupStart;
  String _lastSavedWeekdayGroupEnd = _defaultGroupEnd;
  String _lastSavedWeekendGroupStart = _defaultGroupStart;
  String _lastSavedWeekendGroupEnd = _defaultGroupEnd;
  String _employeeDisplayName = '';
  String? _employeeSpecialization;
  String? _employeePictureUrl;

  int? get _workerId => int.tryParse(widget.args.employeeId);

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime get _today => _dateOnly(DateTime.now());

  SpecialistScheduleLoadQuery? get _loadQuery {
    final id = _workerId;
    if (id == null || id <= 0) return null;
    return SpecialistScheduleLoadQuery(workerId: id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshWorkerPermissions(ref);
    });
    _weekdayGroupStart = _defaultGroupStart;
    _weekdayGroupEnd = _defaultGroupEnd;
    _weekdays = const [];
    _weekendGroupStart = _defaultGroupStart;
    _weekendGroupEnd = _defaultGroupEnd;
    _weekends = const [];
    _workDaysController = TextEditingController(text: '1');
    _offDaysController = TextEditingController(text: '1');
    _shiftStartDate = _today;
  }

  @override
  void dispose() {
    _workDaysController.dispose();
    _offDaysController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d.$m.${date.year}';
  }

  Future<void> _pickShiftStartDate() async {
    final today = _today;
    final current = _shiftStartDate ?? today;
    final initial = current.isBefore(today) ? today : current;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _shiftStartDate = _dateOnly(picked));
  }

  bool get _isWeekSchedule => _scheduleType == 'Неделя';
  bool get _isShiftSchedule => _scheduleType == 'Смена';

  List<SpecialistDayDraft> _cloneDayDrafts(List<SpecialistDayDraft> days) {
    return days
        .map(
          (d) => SpecialistDayDraft(
            label: d.label,
            dayKey: d.dayKey,
            enabled: d.enabled,
            start: d.start,
            end: d.end,
            patternId: d.patternId,
            breakStart: d.breakStart,
            breakEnd: d.breakEnd,
          ),
        )
        .toList();
  }

  void _snapshotSavedWeekSchedule() {
    _lastSavedWeekdays = _cloneDayDrafts(_weekdays);
    _lastSavedWeekends = _cloneDayDrafts(_weekends);
    _lastSavedWeekdayGroupStart = _weekdayGroupStart;
    _lastSavedWeekdayGroupEnd = _weekdayGroupEnd;
    _lastSavedWeekendGroupStart = _weekendGroupStart;
    _lastSavedWeekendGroupEnd = _weekendGroupEnd;
  }

  void _restoreSavedWeekSchedule() {
    _weekdays = _cloneDayDrafts(_lastSavedWeekdays);
    _weekends = _cloneDayDrafts(_lastSavedWeekends);
    _weekdayGroupStart = _lastSavedWeekdayGroupStart;
    _weekdayGroupEnd = _lastSavedWeekdayGroupEnd;
    _weekendGroupStart = _lastSavedWeekendGroupStart;
    _weekendGroupEnd = _lastSavedWeekendGroupEnd;
  }

  void _applyLoadedForm(SpecialistScheduleFormState form) {
    _scheduleType = form.scheduleTypeLabel;
    _weekdays = List.of(form.weekdays);
    _weekends = List.of(form.weekends);
    _weekdayGroupStart = form.weekdayGroupStart;
    _weekdayGroupEnd = form.weekdayGroupEnd;
    _weekendGroupStart = form.weekendGroupStart;
    _weekendGroupEnd = form.weekendGroupEnd;
    _configUuid = form.configUuid;
    _workDaysController.text = form.workDays;
    _offDaysController.text = form.offDays;
    _shiftStartDate = form.scheduleTypeLabel == 'Смена'
        ? _today
        : (form.shiftStartDate != null
            ? _dateOnly(form.shiftStartDate!)
            : _today);
    _shiftWorkStart = form.shiftWorkStart;
    _shiftWorkEnd = form.shiftWorkEnd;
    _employeeDisplayName = form.employeeName;
    _employeeSpecialization = form.employeeSpecialization;
    _employeePictureUrl = form.employeePictureUrl;
    _snapshotSavedWeekSchedule();
  }

  String? get _headerEmployeePictureUrl {
    final fromForm = _employeePictureUrl?.trim();
    if (fromForm != null && fromForm.isNotEmpty) return fromForm;
    final fromArgs = widget.args.pictureUrl?.trim();
    if (fromArgs != null && fromArgs.isNotEmpty) return fromArgs;
    return null;
  }

  String get _headerEmployeeName {
    final fromForm = _employeeDisplayName.trim();
    if (fromForm.isNotEmpty) return fromForm;
    final fromArgs = widget.args.employeeName.trim();
    return fromArgs.isNotEmpty ? fromArgs : 'Сотрудник';
  }

  void _applyGroupTimesToWeekdays() {
    setState(() {
      _weekdays = _weekdays
          .map(
            (d) => d.copyWith(
              start: _weekdayGroupStart,
              end: _weekdayGroupEnd,
            ),
          )
          .toList();
    });
  }

  void _applyGroupTimesToWeekends() {
    setState(() {
      _weekends = _weekends
          .map(
            (d) => d.copyWith(
              start: _weekendGroupStart,
              end: _weekendGroupEnd,
            ),
          )
          .toList();
    });
  }

  Widget _buildDaySection({
    required String groupTitle,
    required bool expanded,
    required String groupStart,
    required String groupEnd,
    required List<SpecialistDayDraft> days,
    required VoidCallback onToggleExpanded,
    required VoidCallback onPickGroupStart,
    required VoidCallback onPickGroupEnd,
    required void Function(int index, SpecialistDayDraft day) onDayChanged,
  }) {
    return _ScheduleDaysSection(
      groupTitle: groupTitle,
      expanded: expanded,
      groupStart: groupStart,
      groupEnd: groupEnd,
      days: days,
      onToggleExpanded: onToggleExpanded,
      onPickGroupStart: onPickGroupStart,
      onPickGroupEnd: onPickGroupEnd,
      onDayEnabledChanged: (index, enabled) {
        onDayChanged(index, days[index].copyWith(enabled: enabled));
      },
      onPickDayStart: (index) => _pickTime(
        days[index].start,
        (v) => onDayChanged(index, days[index].copyWith(start: v)),
      ),
      onPickDayEnd: (index) => _pickTime(
        days[index].end,
        (v) => onDayChanged(index, days[index].copyWith(end: v)),
      ),
      onPickBreakStart: (index) {
        final current = days[index].breakStart ?? '13:00';
        _pickTime(current, (v) {
          onDayChanged(index, days[index].copyWith(breakStart: v));
        });
      },
      onPickBreakEnd: (index) {
        final current = days[index].breakEnd ?? '14:00';
        _pickTime(current, (v) {
          onDayChanged(index, days[index].copyWith(breakEnd: v));
        });
      },
      onClearBreak: (index) {
        onDayChanged(
          index,
          days[index].copyWith(breakStart: null, breakEnd: null),
        );
      },
    );
  }

  Future<void> _pickTime(String current, ValueChanged<String> onPicked) async {
    final picked = await showChangeTimePicker(
      context,
      initialTime: current,
    );
    if (picked == null || !mounted) return;
    onPicked(picked);
  }

  String? _saveValidationError() {
    if (_isWeekSchedule) {
      return validateSpecialistWeekScheduleDays([..._weekdays, ..._weekends]);
    }
    if (_isShiftSchedule) {
      if (_timeToMinutes(_shiftWorkStart) >= _timeToMinutes(_shiftWorkEnd)) {
        return 'Время окончания смены должно быть позже начала';
      }
    }
    return null;
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    final h = int.tryParse(parts.first) ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return h * 60 + m;
  }

  String? _extractApiErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) return data.trim();
    if (data is List) {
      for (final item in data) {
        final message = _extractApiErrorMessage(item);
        if (message != null) return message;
      }
      return null;
    }
    if (data is Map) {
      for (final value in data.values) {
        final message = _extractApiErrorMessage(value);
        if (message != null) return message;
      }
    }
    return null;
  }

  String _saveErrorMessage(Object error) {
    if (error is CustomException && error.causedError is DioException) {
      final dio = error.causedError! as DioException;
      final message = humanizeScheduleApiError(
        _extractApiErrorMessage(dio.response?.data),
      );
      if (message != null) return message;
    }
    return 'Не удалось сохранить график';
  }

  Future<String?> _resolveConfigUuid(int workerId, int branchId) async {
    if (_configUuid != null && _configUuid!.isNotEmpty) return _configUuid;
    final row = await ref.read(workersServiceProvider).getWorkerRow(
          workerId: workerId,
          branchId: branchId,
        );
    final config = row?['schedule_config'];
    if (config is Map) {
      return config['id']?.toString();
    }
    return null;
  }

  Future<void> _onSave() async {
    final workerId = _workerId;
    final branchId = ref.read(currentBranchIdProvider);
    if (workerId == null || workerId <= 0 || branchId == 0) return;

    refreshWorkerPermissions(ref);
    final canChange = await ref.read(canChangeWorkScheduleProvider.future);
    if (!canChange) {
      markWorkScheduleEditBlocked(ref);
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: workScheduleNoPermissionMessage,
        variant: AppServiceMessageVariant.error,
      );
      return;
    }

    final validationError = _saveValidationError();
    if (validationError != null) {
      showAppServiceMessage(
        context,
        message: validationError,
        variant: AppServiceMessageVariant.info,
      );
      return;
    }

    if (_isWeekSchedule && _loadedPatterns.isNotEmpty) {
      final appointmentsConflict =
          await validateSpecialistWeekPatternAgainstAppointments(
        ref: ref,
        branchId: branchId,
        workerId: workerId,
        previousDays: [..._lastSavedWeekdays, ..._lastSavedWeekends],
        newDays: [..._weekdays, ..._weekends],
      );
      if (appointmentsConflict != null) {
        if (!mounted) return;
        setState(_restoreSavedWeekSchedule);
        showAppServiceMessage(
          context,
          message: appointmentsConflict,
          variant: AppServiceMessageVariant.info,
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    try {
      final workDaysText = _workDaysController.text.trim();
      final offDaysText = _offDaysController.text.trim();
      final configBody = buildConfigPatchRequest(
        scheduleTypeLabel: _scheduleType,
        weekdayGroupStart: _weekdayGroupStart,
        weekdayGroupEnd: _weekdayGroupEnd,
        workDays: workDaysText.isEmpty ? '1' : workDaysText,
        offDays: offDaysText.isEmpty ? '1' : offDaysText,
        shiftStartDate: _shiftStartDate,
        shiftWorkStart: _shiftWorkStart,
        shiftWorkEnd: _shiftWorkEnd,
      );

      final configsService = ref.read(workerScheduleConfigsServiceProvider);
      final currentWorkerId = await ref.read(currentWorkerIdProvider.future);
      if (currentWorkerId == workerId) {
        await configsService.updateMyScheduleConfig(body: configBody);
      } else {
        final configUuid = await _resolveConfigUuid(workerId, branchId);
        if (configUuid != null && configUuid.isNotEmpty) {
          await configsService.updateWorkerScheduleConfig(
            workerId: workerId,
            configUuid: configUuid,
            body: configBody,
          );
        }
      }

      if (_isWeekSchedule && _loadedPatterns.isNotEmpty) {
        final batch = buildWorkerPatternsBatchRequest(
          branchId: branchId,
          workerId: workerId,
          originalPatterns: _loadedPatterns,
          allDays: [..._weekdays, ..._weekends],
        );
        if (batch.patterns.isEmpty) {
          throw CustomException(
            causedError: Exception('Нет шаблонов дней для сохранения'),
          );
        }
        await ref
            .read(schedulePatternsServiceProvider)
            .updateWorkerSchedulePatternsBatch(
              workerId: workerId,
              body: batch,
            );
      }

      final loadQuery = _loadQuery;
      if (loadQuery != null) {
        ref.invalidate(specialistScheduleFormProvider(loadQuery));
      }
      bumpWorkScheduleReloadToken(ref);

      if (!mounted) return;
      _snapshotSavedWeekSchedule();
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      if (isScheduleAppointmentConflictError(e)) {
        setState(_restoreSavedWeekSchedule);
      }
      if (isWorkSchedulePermissionError(e)) {
        markWorkScheduleEditBlocked(ref);
      }
      showAppServiceMessage(
        context,
        message: _saveErrorMessage(e),
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final accent = AppColors.themeAccent(context);
    final loadQuery = _loadQuery;

    if (loadQuery == null) {
      return Scaffold(
        backgroundColor: screenBackground,
        body: const Center(child: Text('Некорректный сотрудник')),
      );
    }

    final formAsync = ref.watch(specialistScheduleFormProvider(loadQuery));

    return formAsync.when(
      loading: () => Scaffold(
        backgroundColor: screenBackground,
        body: const Center(child: LoadingWidget()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: screenBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Не удалось загрузить график',
              style: AppFonts.b1Medium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (form) {
        if (!_formInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _applyLoadedForm(form);
              _loadedPatterns = form.loadedPatterns;
              _formInitialized = true;
            });
          });
          return Scaffold(
            backgroundColor: screenBackground,
            body: const Center(child: LoadingWidget()),
          );
        }
        return _buildForm(context, isDark, screenBackground, accent);
      },
    );
  }

  Future<void> _onPullToRefresh() async {
    final loadQuery = _loadQuery;
    if (loadQuery == null) return;
    ref.invalidate(specialistScheduleFormProvider(loadQuery));
    try {
      final form =
          await ref.read(specialistScheduleFormProvider(loadQuery).future);
      if (!mounted) return;
      setState(() {
        _applyLoadedForm(form);
        _loadedPatterns = form.loadedPatterns;
      });
    } catch (_) {}
  }

  Widget _buildForm(
    BuildContext context,
    bool isDark,
    Color screenBackground,
    Color accent,
  ) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: null,
      body: Column(
        children: [
          _SpecialistScheduleHeader(
            onBack: () => context.pop(),
            scheduleTitle:
                ref.watch(workerEntityLabelsProvider).value?.scheduleOfWorker ??
                WorkerEntityLabels.defaults.scheduleOfWorker,
            employeeName: _headerEmployeeName,
            employeePosition: _employeeSpecialization,
            employeePictureUrl: _headerEmployeePictureUrl,
            scheduleType: _scheduleType,
            scheduleTypes: _scheduleTypes,
            onScheduleTypeChanged: (value) => setState(() {
              _scheduleType = value;
              if (value == 'Смена') {
                _shiftStartDate = _today;
              }
            }),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: _onPullToRefresh,
              child: ListView(
                physics: AppRefreshIndicator.scrollPhysics,
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                children: [
                _SpecialistScheduleCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isWeekSchedule) ...[
                        _buildDaySection(
                          groupTitle: 'ПН–ПТ',
                          expanded: _weekdaysExpanded,
                          groupStart: _weekdayGroupStart,
                          groupEnd: _weekdayGroupEnd,
                          days: _weekdays,
                          onToggleExpanded: () {
                            setState(
                              () => _weekdaysExpanded = !_weekdaysExpanded,
                            );
                          },
                          onPickGroupStart: () =>
                              _pickTime(_weekdayGroupStart, (v) {
                            setState(() => _weekdayGroupStart = v);
                            _applyGroupTimesToWeekdays();
                          }),
                          onPickGroupEnd: () => _pickTime(_weekdayGroupEnd, (v) {
                            setState(() => _weekdayGroupEnd = v);
                            _applyGroupTimesToWeekdays();
                          }),
                          onDayChanged: (index, day) {
                            setState(() => _weekdays[index] = day);
                          },
                        ),
                        _SpecialistScheduleDivider(isDark: isDark),
                        _buildDaySection(
                          groupTitle: 'СБ–ВС',
                          expanded: _weekendsExpanded,
                          groupStart: _weekendGroupStart,
                          groupEnd: _weekendGroupEnd,
                          days: _weekends,
                          onToggleExpanded: () {
                            setState(
                              () => _weekendsExpanded = !_weekendsExpanded,
                            );
                          },
                          onPickGroupStart: () =>
                              _pickTime(_weekendGroupStart, (v) {
                            setState(() => _weekendGroupStart = v);
                            _applyGroupTimesToWeekends();
                          }),
                          onPickGroupEnd: () => _pickTime(_weekendGroupEnd, (v) {
                            setState(() => _weekendGroupEnd = v);
                            _applyGroupTimesToWeekends();
                          }),
                          onDayChanged: (index, day) {
                            setState(() => _weekends[index] = day);
                          },
                        ),
                      ],
                      if (_isShiftSchedule)
                        _ShiftScheduleCard(
                          workDaysController: _workDaysController,
                          offDaysController: _offDaysController,
                          startDate: _shiftStartDate,
                          workStart: _shiftWorkStart,
                          workEnd: _shiftWorkEnd,
                          onPickDate: _pickShiftStartDate,
                          onPickWorkStart: () => _pickTime(_shiftWorkStart, (v) {
                            setState(() => _shiftWorkStart = v);
                          }),
                          onPickWorkEnd: () => _pickTime(_shiftWorkEnd, (v) {
                            setState(() => _shiftWorkEnd = v);
                          }),
                          formatDate: _formatDate,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryWhiteDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainButton(
                  title: 'Отменить',
                  color: isDark
                      ? AppColors.secondaryDarkLight
                      : AppColors.secondaryLight,
                  textColor: accent,
                  onTap: () => context.pop(),
                ),
                const Gap(12),
                MainButton(
                  title: 'Сохранить',
                  isLoading: _isSaving,
                  isActive: !_isSaving,
                  onTap: _onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialistScheduleCard extends StatelessWidget {
  const _SpecialistScheduleCard({
    required this.isDark,
    required this.child,
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryWhiteDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _SpecialistScheduleDivider extends StatelessWidget {
  const _SpecialistScheduleDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark,
    );
  }
}

class _SpecialistScheduleHeader extends StatelessWidget {
  const _SpecialistScheduleHeader({
    required this.onBack,
    required this.scheduleTitle,
    required this.employeeName,
    this.employeePosition,
    this.employeePictureUrl,
    required this.scheduleType,
    required this.scheduleTypes,
    required this.onScheduleTypeChanged,
  });

  final VoidCallback onBack;
  final String scheduleTitle;
  final String employeeName;
  final String? employeePosition;
  final String? employeePictureUrl;
  final String scheduleType;
  final List<String> scheduleTypes;
  final ValueChanged<String> onScheduleTypeChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final circleColor = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;

    return DefaultContainerWidget(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _HeaderIconButton(
                color: circleColor,
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: iconColor,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  scheduleTitle,
                  style: AppFonts.h3Medium.copyWith(
                    color: isDark
                        ? AppColors.primaryWhite
                        : AppColors.primaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(12),
          _SpecialistEmployeeInfo(
            name: employeeName,
            position: employeePosition,
            pictureUrl: employeePictureUrl,
          ),
          const Gap(12),
          _ScheduleTypeRow(
            value: scheduleType,
            options: scheduleTypes,
            onChanged: onScheduleTypeChanged,
            padding: const EdgeInsets.only(bottom: 2),
          ),
        ],
      ),
    );
  }
}

class _SpecialistEmployeeInfo extends StatelessWidget {
  const _SpecialistEmployeeInfo({
    required this.name,
    this.position,
    this.pictureUrl,
  });

  final String name;
  final String? position;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final positionColor =
        isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey;
    final positionText = position?.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SpecialistEmployeeAvatar(name: name, pictureUrl: pictureUrl),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppFonts.b1Medium.copyWith(color: nameColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (positionText != null && positionText.isNotEmpty) ...[
                const Gap(4),
                Text(
                  positionText,
                  style: AppFonts.b2Regular.copyWith(color: positionColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecialistEmployeeAvatar extends StatelessWidget {
  const _SpecialistEmployeeAvatar({
    required this.name,
    this.pictureUrl,
  });

  final String name;
  final String? pictureUrl;

  static const _size = 48.0;

  @override
  Widget build(BuildContext context) {
    final url = pictureUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: _size,
          height: _size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDarkDark : AppColors.forthLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: AppFonts.b2Medium.copyWith(
          color: AppColors.themeAccent(context),
        ),
      ),
    );
  }

  String _initials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '—';
    final first = parts[0].substring(0, 1).toUpperCase();
    if (parts.length == 1) return first;
    return '$first${parts[1].substring(0, 1).toUpperCase()}';
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.color,
    required this.onTap,
    required this.child,
  });

  final Color color;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _ScheduleTypeRow extends StatelessWidget {
  const _ScheduleTypeRow({
    required this.value,
    required this.options,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            'Тип расписания',
            style: AppFonts.b1Medium.copyWith(color: textColor),
          ),
          const Spacer(),
          _ScheduleTypeDropdown(
            value: value,
            options: options,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ScheduleTypeDropdown extends StatelessWidget {
  const _ScheduleTypeDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);

    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(option, style: AppFonts.c1Regular),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight,
          borderRadius: AppDecoration.borderRadius300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppFonts.c1Medium.copyWith(color: accent),
            ),
            const Gap(4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: accent),
          ],
        ),
      ),
    );
  }
}

class _ShiftScheduleCard extends StatelessWidget {
  const _ShiftScheduleCard({
    required this.workDaysController,
    required this.offDaysController,
    required this.startDate,
    required this.workStart,
    required this.workEnd,
    required this.onPickDate,
    required this.onPickWorkStart,
    required this.onPickWorkEnd,
    required this.formatDate,
  });

  final TextEditingController workDaysController;
  final TextEditingController offDaysController;
  final DateTime? startDate;
  final String workStart;
  final String workEnd;
  final VoidCallback onPickDate;
  final VoidCallback onPickWorkStart;
  final VoidCallback onPickWorkEnd;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;
    final accent = AppColors.themeAccent(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Рабочие дни',
                  textAlign: TextAlign.center,
                  style: AppFonts.c1Medium.copyWith(color: labelColor),
                ),
              ),
              Text(
                '/',
                style: AppFonts.c1Regular.copyWith(color: AppColors.tabbarGrey),
              ),
              Expanded(
                child: Text(
                  'Выходные дни',
                  textAlign: TextAlign.center,
                  style: AppFonts.c1Medium.copyWith(color: labelColor),
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: _ShiftNumberField(controller: workDaysController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '/',
                  style: AppFonts.c1Regular.copyWith(color: AppColors.tabbarGrey),
                ),
              ),
              Expanded(
                child: _ShiftNumberField(controller: offDaysController),
              ),
            ],
          ),
          const Gap(12),
          Divider(height: 1, thickness: 1, color: dividerColor),
          const Gap(12),
          Row(
            children: [
              Text(
                'Дата начала',
                style: AppFonts.b1Medium.copyWith(color: labelColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onPickDate,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.secondaryDarkLight
                        : AppColors.secondaryLight,
                    borderRadius: AppDecoration.borderRadius300,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        startDate == null
                            ? 'Выберите дату'
                            : formatDate(startDate!),
                        style: AppFonts.c1Medium.copyWith(
                          color: startDate == null
                              ? AppColors.tabbarGrey
                              : labelColor,
                        ),
                      ),
                      const Gap(8),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: accent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Divider(height: 1, thickness: 1, color: dividerColor),
          const Gap(12),
          Row(
            children: [
              Text(
                'Время работы',
                style: AppFonts.b1Medium.copyWith(color: labelColor),
              ),
              const Spacer(),
              _TimeRangeFields(
                start: workStart,
                end: workEnd,
                onPickStart: onPickWorkStart,
                onPickEnd: onPickWorkEnd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShiftNumberField extends StatelessWidget {
  const _ShiftNumberField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight,
        borderRadius: AppDecoration.borderRadius300,
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppFonts.c1Medium.copyWith(color: textColor),
        decoration: InputDecoration(
          hintText: 'Напишите число',
          hintStyle: AppFonts.c1Regular.copyWith(color: AppColors.tabbarGrey),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}

class _ScheduleDaysSection extends StatelessWidget {
  const _ScheduleDaysSection({
    required this.groupTitle,
    required this.expanded,
    required this.groupStart,
    required this.groupEnd,
    required this.days,
    required this.onToggleExpanded,
    required this.onPickGroupStart,
    required this.onPickGroupEnd,
    required this.onDayEnabledChanged,
    required this.onPickDayStart,
    required this.onPickDayEnd,
    required this.onPickBreakStart,
    required this.onPickBreakEnd,
    required this.onClearBreak,
  });

  final String groupTitle;
  final bool expanded;
  final String groupStart;
  final String groupEnd;
  final List<SpecialistDayDraft> days;
  final VoidCallback onToggleExpanded;
  final VoidCallback onPickGroupStart;
  final VoidCallback onPickGroupEnd;
  final void Function(int index, bool enabled) onDayEnabledChanged;
  final void Function(int index) onPickDayStart;
  final void Function(int index) onPickDayEnd;
  final void Function(int index) onPickBreakStart;
  final void Function(int index) onPickBreakEnd;
  final void Function(int index) onClearBreak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggleExpanded,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      size: 22,
                      color: AppColors.themeAccent(context),
                    ),
                    const Gap(4),
                    Text(
                      groupTitle,
                      style: AppFonts.b1Medium.copyWith(
                        color: isDark
                            ? AppColors.primaryWhite
                            : AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _TimeRangeFields(
                start: groupStart,
                end: groupEnd,
                onPickStart: onPickGroupStart,
                onPickEnd: onPickGroupEnd,
              ),
            ],
          ),
        ),
        if (expanded)
          for (var i = 0; i < days.length; i++) ...[
            Divider(height: 1, thickness: 1, color: dividerColor),
            _DayScheduleContent(
              day: days[i],
              onEnabledChanged: (enabled) =>
                  onDayEnabledChanged(i, enabled),
              onPickStart: () => onPickDayStart(i),
              onPickEnd: () => onPickDayEnd(i),
              onPickBreakStart: () => onPickBreakStart(i),
              onPickBreakEnd: () => onPickBreakEnd(i),
              onClearBreak: () => onClearBreak(i),
            ),
          ],
      ],
    );
  }
}

bool _specialistDayBreakIsSet(SpecialistDayDraft day) {
  final start = day.breakStart?.trim() ?? '';
  final end = day.breakEnd?.trim() ?? '';
  return start.isNotEmpty || end.isNotEmpty;
}

class _DayScheduleContent extends StatelessWidget {
  const _DayScheduleContent({
    required this.day,
    required this.onEnabledChanged,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onPickBreakStart,
    required this.onPickBreakEnd,
    required this.onClearBreak,
  });

  final SpecialistDayDraft day;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback onPickBreakStart;
  final VoidCallback onPickBreakEnd;
  final VoidCallback onClearBreak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLabelColor =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final inactiveLabelColor = AppColors.tabbarGrey;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              CustomSwitchWidget(
                value: day.enabled,
                onChanged: onEnabledChanged,
              ),
              const Gap(8),
              SizedBox(
                width: 28,
                child: Text(
                  day.label.toLowerCase(),
                  style: AppFonts.b1Medium.copyWith(
                    color: day.enabled ? activeLabelColor : inactiveLabelColor,
                  ),
                ),
              ),
              const Spacer(),
              _TimeRangeFields(
                start: day.start,
                end: day.end,
                enabled: day.enabled,
                onPickStart: onPickStart,
                onPickEnd: onPickEnd,
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                'Перерыв',
                style: AppFonts.c1Regular.copyWith(
                  color: (day.enabled ? activeLabelColor : inactiveLabelColor)
                      .withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              _TimeRangeFields(
                start: day.breakStart,
                end: day.breakEnd,
                enabled: day.enabled,
                placeholder: true,
                onPickStart: onPickBreakStart,
                onPickEnd: onPickBreakEnd,
              ),
            ],
          ),
          if (day.enabled && _specialistDayBreakIsSet(day)) ...[
            const Gap(6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onClearBreak,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Сбросить перерыв',
                  style: AppFonts.c1Medium.copyWith(
                    color: AppColors.themeAccent(context),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeRangeFields extends StatelessWidget {
  const _TimeRangeFields({
    required this.start,
    required this.end,
    required this.onPickStart,
    required this.onPickEnd,
    this.enabled = true,
    this.placeholder = false,
  });

  final String? start;
  final String? end;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final bool enabled;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimePill(
          value: start,
          placeholder: placeholder,
          enabled: enabled,
          onTap: enabled ? onPickStart : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '–',
            style: AppFonts.c1Regular.copyWith(
              color: enabled
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryWhite
                      : AppColors.primaryDark)
                  : AppColors.tabbarGrey,
            ),
          ),
        ),
        _TimePill(
          value: end,
          placeholder: placeholder,
          enabled: enabled,
          onTap: enabled ? onPickEnd : null,
        ),
      ],
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({
    required this.value,
    required this.placeholder,
    required this.enabled,
    this.onTap,
  });

  final String? value;
  final bool placeholder;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = value != null && value!.isNotEmpty;
    // Как в строке «ПН–ПТ»: один фон для всех полей времени.
    final fillColor =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final textColor = !enabled || !hasValue
        ? AppColors.tabbarGrey.withValues(alpha: 0.5)
        : (isDark ? AppColors.primaryWhite : AppColors.primaryDark);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 58,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: AppDecoration.borderRadius300,
        ),
        child: Text(
          hasValue ? value! : (placeholder ? '' : '--:--'),
          style: AppFonts.c1Medium.copyWith(
            color: textColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
