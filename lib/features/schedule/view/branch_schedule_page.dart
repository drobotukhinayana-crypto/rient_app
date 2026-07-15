import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/change_time_picker_dialog.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/utils/work_schedule_appointment_conflict.dart'
    show
        humanizeScheduleApiError,
        isWorkSchedulePermissionError,
        workScheduleNoPermissionMessage;
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_week_days_section.dart';
import 'package:rient_app/features/schedule/view/providers/branch_schedule_loader.dart';
import 'package:rient_app/features/schedule/view/providers/branch_schedule_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_branch_provider.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_loader.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
import 'package:rient_app/resources/resources.dart';

class BranchSchedulePageArgs {
  const BranchSchedulePageArgs({
    required this.branchId,
    required this.branchName,
  });

  final int branchId;
  final String branchName;
}

/// Результат сохранения — актуальные шаблоны для мгновенного обновления сетки.
class BranchScheduleSaveResult {
  const BranchScheduleSaveResult({required this.patterns});

  final List<SchedulePatternBranchItemApi> patterns;
}

class BranchSchedulePage extends ConsumerStatefulWidget {
  const BranchSchedulePage({super.key, required this.args});

  final BranchSchedulePageArgs args;

  static const name = 'branch_schedule_page';
  static const path = 'branch_schedule';

  @override
  ConsumerState<BranchSchedulePage> createState() => _BranchSchedulePageState();
}

class _BranchSchedulePageState extends ConsumerState<BranchSchedulePage> {
  static const _defaultGroupStart = '09:00';
  static const _defaultGroupEnd = '20:00';

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

  List<SchedulePatternBranchItemApi> _loadedPatterns = const [];
  String _branchDisplayName = '';

  int get _branchId => widget.args.branchId;

  bool _canChangeBranchWorkSchedule() {
    final roleId = ref.read(roleProvider);
    return roleId == UserRole.owner.value || roleId == UserRole.manager.value;
  }

  @override
  void initState() {
    super.initState();
    _weekdayGroupStart = _defaultGroupStart;
    _weekdayGroupEnd = _defaultGroupEnd;
    _weekdays = const [];
    _weekendGroupStart = _defaultGroupStart;
    _weekendGroupEnd = _defaultGroupEnd;
    _weekends = const [];
  }

  void _applyLoadedForm(BranchScheduleFormState form) {
    _weekdays = List.of(form.weekdays);
    _weekends = List.of(form.weekends);
    _weekdayGroupStart = form.weekdayGroupStart;
    _weekdayGroupEnd = form.weekdayGroupEnd;
    _weekendGroupStart = form.weekendGroupStart;
    _weekendGroupEnd = form.weekendGroupEnd;
    _branchDisplayName = form.branchName;
  }

  String get _headerBranchName {
    final fromForm = _branchDisplayName.trim();
    if (fromForm.isNotEmpty) return fromForm;
    final fromArgs = widget.args.branchName.trim();
    return fromArgs.isNotEmpty ? fromArgs : 'Филиал';
  }

  void _applyGroupTimesToWeekdays() {
    setState(() {
      _weekdays = _weekdays
          .map(
            (day) => day.copyWith(
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
            (day) => day.copyWith(
              start: _weekendGroupStart,
              end: _weekendGroupEnd,
            ),
          )
          .toList();
    });
  }

  Future<void> _pickTime(String current, ValueChanged<String> onPicked) async {
    final picked = await showChangeTimePicker(
      context,
      initialTime: current,
    );
    if (picked == null || !mounted) return;
    onPicked(picked);
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

  Future<void> _onSave() async {
    final branchId = _branchId;
    if (branchId <= 0) return;

    if (!_canChangeBranchWorkSchedule()) {
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: 'Изменять график филиала могут только владелец и менеджер',
        variant: AppServiceMessageVariant.error,
      );
      return;
    }

    final validationError =
        validateSpecialistWeekScheduleDays([..._weekdays, ..._weekends]);
    if (validationError != null) {
      showAppServiceMessage(
        context,
        message: validationError,
        variant: AppServiceMessageVariant.info,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final allDays = [..._weekdays, ..._weekends];
      final fallbackBranchPatterns =
          ref.read(currentBranchProvider)?.schedulePatterns;
      final batch = buildBranchPatternsBatchRequest(
        originalPatterns: _loadedPatterns,
        allDays: allDays,
        fallbackBranchPatterns: fallbackBranchPatterns,
        branchId: branchId,
      );
      if (batch.patterns.isEmpty) {
        throw CustomException(
          causedError: Exception('Нет шаблонов дней для сохранения'),
        );
      }

      for (final day in allDays) {
        if (!day.enabled) continue;
        final dayKey = canonicalScheduleDayKey(day.dayKey);
        final inBatch = batch.patterns.any(
          (item) => canonicalScheduleDayKey(item.day) == dayKey,
        );
        if (!inBatch) {
          showAppServiceMessage(
            context,
            message:
                '«${day.label}»: не удалось найти шаблон филиала для сохранения',
            variant: AppServiceMessageVariant.error,
          );
          return;
        }
      }

      await ref.read(schedulePatternsServiceProvider).updateBranchSchedulePatternsBatch(
            branchId: branchId,
            body: batch,
          );

      final savedPatterns = buildBranchPatternsAfterSave(
        originalPatterns: _loadedPatterns,
        allDays: allDays,
        fallbackBranchPatterns: fallbackBranchPatterns,
        branchId: branchId,
      );

      ref.invalidate(branchScheduleFormProvider(branchId));
      ref.invalidate(branchSchedulePatternsBranchProvider(branchId));
      ref.invalidate(branchesProvider);
      try {
        await ref.read(branchesProvider.future);
      } catch (_) {}
      invalidateWorkScheduleCaches(ref, branchId: branchId);

      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && route.isCurrent && context.canPop()) {
        context.pop(BranchScheduleSaveResult(patterns: savedPatterns));
      }
    } catch (e) {
      if (!mounted) return;
      if (isWorkSchedulePermissionError(e)) {
        showAppServiceMessage(
          context,
          message: workScheduleNoPermissionMessage,
          variant: AppServiceMessageVariant.error,
        );
        return;
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

  Future<void> _onPullToRefresh() async {
    final branchId = _branchId;
    if (branchId <= 0) return;
    ref.invalidate(branchScheduleFormProvider(branchId));
    try {
      final form = await ref.read(branchScheduleFormProvider(branchId).future);
      if (!mounted) return;
      setState(() {
        _applyLoadedForm(form);
        _loadedPatterns = form.loadedPatterns;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final accent = AppColors.themeAccent(context);
    final branchId = _branchId;

    if (branchId <= 0) {
      return Scaffold(
        backgroundColor: screenBackground,
        body: const Center(child: Text('Некорректный филиал')),
      );
    }

    final formAsync = ref.watch(branchScheduleFormProvider(branchId));

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

  Widget _buildForm(
    BuildContext context,
    bool isDark,
    Color screenBackground,
    Color accent,
  ) {
    return Scaffold(
      backgroundColor: screenBackground,
      body: Column(
        children: [
          _BranchScheduleHeader(
            onBack: () => context.pop(),
            branchName: _headerBranchName,
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: _onPullToRefresh,
              child: ListView(
                physics: AppRefreshIndicator.scrollPhysics,
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                children: [
                  _BranchScheduleCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        WorkScheduleWeekDaysSection(
                          groupTitle: 'ПН–ПТ',
                          expanded: _weekdaysExpanded,
                          groupStart: _weekdayGroupStart,
                          groupEnd: _weekdayGroupEnd,
                          days: _weekdays,
                          showBreaks: false,
                          onToggleExpanded: () {
                            setState(
                              () => _weekdaysExpanded = !_weekdaysExpanded,
                            );
                          },
                          onPickGroupStart: () =>
                              _pickTime(_weekdayGroupStart, (value) {
                            setState(() => _weekdayGroupStart = value);
                            _applyGroupTimesToWeekdays();
                          }),
                          onPickGroupEnd: () => _pickTime(_weekdayGroupEnd, (value) {
                            setState(() => _weekdayGroupEnd = value);
                            _applyGroupTimesToWeekdays();
                          }),
                          onDayEnabledChanged: (index, enabled) {
                            setState(
                              () => _weekdays[index] =
                                  _weekdays[index].copyWith(enabled: enabled),
                            );
                          },
                          onPickDayStart: (index) => _pickTime(
                            _weekdays[index].start,
                            (value) => setState(
                              () => _weekdays[index] =
                                  _weekdays[index].copyWith(start: value),
                            ),
                          ),
                          onPickDayEnd: (index) => _pickTime(
                            _weekdays[index].end,
                            (value) => setState(
                              () => _weekdays[index] =
                                  _weekdays[index].copyWith(end: value),
                            ),
                          ),
                        ),
                        _BranchScheduleDivider(isDark: isDark),
                        WorkScheduleWeekDaysSection(
                          groupTitle: 'СБ–ВС',
                          expanded: _weekendsExpanded,
                          groupStart: _weekendGroupStart,
                          groupEnd: _weekendGroupEnd,
                          days: _weekends,
                          showBreaks: false,
                          onToggleExpanded: () {
                            setState(
                              () => _weekendsExpanded = !_weekendsExpanded,
                            );
                          },
                          onPickGroupStart: () =>
                              _pickTime(_weekendGroupStart, (value) {
                            setState(() => _weekendGroupStart = value);
                            _applyGroupTimesToWeekends();
                          }),
                          onPickGroupEnd: () => _pickTime(_weekendGroupEnd, (value) {
                            setState(() => _weekendGroupEnd = value);
                            _applyGroupTimesToWeekends();
                          }),
                          onDayEnabledChanged: (index, enabled) {
                            setState(
                              () => _weekends[index] =
                                  _weekends[index].copyWith(enabled: enabled),
                            );
                          },
                          onPickDayStart: (index) => _pickTime(
                            _weekends[index].start,
                            (value) => setState(
                              () => _weekends[index] =
                                  _weekends[index].copyWith(start: value),
                            ),
                          ),
                          onPickDayEnd: (index) => _pickTime(
                            _weekends[index].end,
                            (value) => setState(
                              () => _weekends[index] =
                                  _weekends[index].copyWith(end: value),
                            ),
                          ),
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

class _BranchScheduleCard extends StatelessWidget {
  const _BranchScheduleCard({
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

class _BranchScheduleDivider extends StatelessWidget {
  const _BranchScheduleDivider({required this.isDark});

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

class _BranchScheduleHeader extends StatelessWidget {
  const _BranchScheduleHeader({
    required this.onBack,
    required this.branchName,
  });

  final VoidCallback onBack;
  final String branchName;

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
                  'График филиала',
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
          _BranchInfo(name: branchName),
        ],
      ),
    );
  }
}

class _BranchInfo extends StatelessWidget {
  const _BranchInfo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _BranchAvatar(isDark: isDark),
        const Gap(12),
        Expanded(
          child: Text(
            name,
            style: AppFonts.b1Medium.copyWith(color: nameColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _BranchAvatar extends StatelessWidget {
  const _BranchAvatar({required this.isDark});

  final bool isDark;

  static const _size = 48.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryDark,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isDark
          ? ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.primaryWhite,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                AppImages.branch,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            )
          : Image.asset(
              AppImages.branch,
              width: 26,
              height: 26,
              fit: BoxFit.contain,
            ),
    );
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
