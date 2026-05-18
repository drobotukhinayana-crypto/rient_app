import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/change_time_picker_dialog.dart';
import 'package:rient_app/core/widgets/custom_switch_widget.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/service/worker_schedule_configs_service.dart';
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

  int? get _workerId => int.tryParse(widget.args.employeeId);

  SpecialistScheduleLoadQuery? get _loadQuery {
    final id = _workerId;
    if (id == null || id <= 0) return null;
    return SpecialistScheduleLoadQuery(workerId: id);
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
    _workDaysController = TextEditingController(text: '1');
    _offDaysController = TextEditingController(text: '1');
    _shiftStartDate = DateTime.now();
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
    final initial = _shiftStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ru'),
    );
    if (picked == null || !mounted) return;
    setState(() => _shiftStartDate = picked);
  }

  bool get _isWeekSchedule => _scheduleType == 'Неделя';
  bool get _isShiftSchedule => _scheduleType == 'Смена';

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
    _shiftStartDate = form.shiftStartDate ?? DateTime.now();
    _shiftWorkStart = form.shiftWorkStart;
    _shiftWorkEnd = form.shiftWorkEnd;
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

  Future<void> _onSave() async {
    final workerId = _workerId;
    final branchId = ref.read(currentBranchIdProvider);
    if (workerId == null || workerId <= 0 || branchId == 0) return;

    setState(() => _isSaving = true);
    try {
      final configBody = buildConfigPatchRequest(
        scheduleTypeLabel: _scheduleType,
        weekdayGroupStart: _weekdayGroupStart,
        weekdayGroupEnd: _weekdayGroupEnd,
        workDays: _workDaysController.text.trim(),
        offDays: _offDaysController.text.trim(),
        shiftStartDate: _shiftStartDate,
        shiftWorkStart: _shiftWorkStart,
        shiftWorkEnd: _shiftWorkEnd,
      );

      final configsService = ref.read(workerScheduleConfigsServiceProvider);
      final currentWorkerId = await ref.read(currentWorkerIdProvider.future);
      if (currentWorkerId == workerId) {
        await configsService.updateMyScheduleConfig(body: configBody);
      } else if (_configUuid != null && _configUuid!.isNotEmpty) {
        await configsService.updateWorkerScheduleConfig(
          workerId: workerId,
          configUuid: _configUuid!,
          body: configBody,
        );
      }

      if (_isWeekSchedule && _loadedPatterns.isNotEmpty) {
        final batch = buildWorkerPatternsBatchRequest(
          branchId: branchId,
          originalPatterns: _loadedPatterns,
          allDays: [..._weekdays, ..._weekends],
        );
        if (batch.patterns.isNotEmpty) {
          await ref.read(schedulePatternsServiceProvider).updateWorkerSchedulePatternsBatch(
                workerId: workerId,
                body: batch,
              );
        }
      }

      final loadQuery = _loadQuery;
      if (loadQuery != null) {
        ref.invalidate(specialistScheduleFormProvider(loadQuery));
      }
      ref.invalidate(workScheduleMonthProvider);

      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось сохранить график')),
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
          _SpecialistScheduleHeader(
            onBack: () => context.pop(),
            onMore: () {},
          ),
          Expanded(
            child: ListView(
              padding: AppDecoration.padding16.copyWith(top: 12, bottom: 16),
              children: [
                _ScheduleTypeRow(
                  value: _scheduleType,
                  options: _scheduleTypes,
                  onChanged: (value) => setState(() => _scheduleType = value),
                ),
                if (_isWeekSchedule) ...[
                  const Gap(12),
                  _buildDaySection(
                    groupTitle: 'ПН–ПТ',
                    expanded: _weekdaysExpanded,
                    groupStart: _weekdayGroupStart,
                    groupEnd: _weekdayGroupEnd,
                    days: _weekdays,
                    onToggleExpanded: () {
                      setState(() => _weekdaysExpanded = !_weekdaysExpanded);
                    },
                    onPickGroupStart: () => _pickTime(_weekdayGroupStart, (v) {
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
                  const Gap(12),
                  _buildDaySection(
                    groupTitle: 'СБ–ВС',
                    expanded: _weekendsExpanded,
                    groupStart: _weekendGroupStart,
                    groupEnd: _weekendGroupEnd,
                    days: _weekends,
                    onToggleExpanded: () {
                      setState(() => _weekendsExpanded = !_weekendsExpanded);
                    },
                    onPickGroupStart: () => _pickTime(_weekendGroupStart, (v) {
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
                if (_isShiftSchedule) ...[
                  const Gap(12),
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
              ],
            ),
          ),
          Container(
            color: isDark ? AppColors.primaryWhiteDark : Colors.white,
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

class _SpecialistScheduleHeader extends StatelessWidget {
  const _SpecialistScheduleHeader({
    required this.onBack,
    required this.onMore,
  });

  final VoidCallback onBack;
  final VoidCallback onMore;

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
        bottom: 12,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Row(
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
              'График специалиста',
              style: AppFonts.h3Medium.copyWith(
                color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
              ),
            ),
          ),
          _HeaderIconButton(
            color: circleColor,
            onTap: onMore,
            child: Icon(
              Icons.more_horiz_rounded,
              size: 22,
              color: AppColors.themeAccent(context),
            ),
          ),
        ],
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

class _ScheduleTypeRow extends StatelessWidget {
  const _ScheduleTypeRow({
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
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final textColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final labelColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;
    final accent = AppColors.themeAccent(context);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              ),
            ],
        ],
      ),
    );
  }
}

class _DayScheduleContent extends StatelessWidget {
  const _DayScheduleContent({
    required this.day,
    required this.onEnabledChanged,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onPickBreakStart,
    required this.onPickBreakEnd,
  });

  final SpecialistDayDraft day;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback onPickBreakStart;
  final VoidCallback onPickBreakEnd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLabelColor =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final inactiveLabelColor = AppColors.tabbarGrey;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
              color: AppColors.tabbarGrey,
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
    final fillColor = !enabled
        ? (isDark ? AppColors.forthLightDark : AppColors.forthLight)
        : (isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight);

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
            color: hasValue
                ? (isDark ? AppColors.primaryWhite : AppColors.primaryDark)
                : AppColors.tabbarGrey.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
