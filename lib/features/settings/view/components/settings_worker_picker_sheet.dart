import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/features/settings/service/settings_service.dart';
import 'package:rient_app/resources/resources.dart';

enum SettingsWorkerAction {
  resetAccess(
    title: 'Сбросить доступ сотруднику',
    confirmLabel: 'Сбросить',
    successMessage: 'Доступ сотрудника сброшен',
  ),
  prohibitOnlineBooking(
    title: 'Запретить онлайн запись',
    confirmLabel: 'Запретить',
    successMessage: 'Онлайн запись запрещена',
  );

  const SettingsWorkerAction({
    required this.title,
    required this.confirmLabel,
    required this.successMessage,
  });

  final String title;
  final String confirmLabel;
  final String successMessage;
}

SpecialistItem _allSpecialistsItem(WorkerEntityLabels labels) => SpecialistItem(
  name: labels.allWorkers,
  role: '',
);

final settingsPickerWorkersProvider = FutureProvider.autoDispose
    .family<List<WorkerApi>, SettingsWorkerAction>((ref, action) {
  final service = ref.watch(settingsServiceProvider);
  switch (action) {
    case SettingsWorkerAction.resetAccess:
      return service.loadAllBranchWorkersForPicker();
    case SettingsWorkerAction.prohibitOnlineBooking:
      return service.loadActiveBranchWorkersForPicker();
  }
});

class SettingsWorkerPickerSheet extends ConsumerStatefulWidget {
  const SettingsWorkerPickerSheet({super.key, required this.action});

  final SettingsWorkerAction action;

  static Future<void> show(
    BuildContext context, {
    required SettingsWorkerAction action,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => SettingsWorkerPickerSheet(action: action),
    );
  }

  @override
  ConsumerState<SettingsWorkerPickerSheet> createState() =>
      _SettingsWorkerPickerSheetState();
}

class _SettingsWorkerPickerSheetState
    extends ConsumerState<SettingsWorkerPickerSheet> {
  late SpecialistItem _selected;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selected = _allSpecialistsItem(WorkerEntityLabels.defaults);
    _searchController.addListener(() {
      setState(
        () => _searchQuery = _searchController.text.trim().toLowerCase(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String _workerDisplayName(WorkerApi worker, WorkerEntityLabels labels) {
    final name =
        '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim();
    return labels.personDisplayName(name);
  }

  static List<SpecialistItem> _specialistsFromWorkers(
    List<WorkerApi> workers,
    WorkerEntityLabels labels,
  ) {
    return [
      _allSpecialistsItem(labels),
      for (final worker in workers)
        SpecialistItem(
          name: _workerDisplayName(worker, labels),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        ),
    ];
  }

  List<SpecialistItem> _filter(List<SpecialistItem> specialists) {
    if (_searchQuery.isEmpty) return specialists;
    return specialists.where((s) {
      return s.name.toLowerCase().contains(_searchQuery) ||
          s.role.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _onConfirm(List<SpecialistItem> allSpecialists) async {
    if (_isSubmitting) return;

    final workerIds = allSpecialists
        .where((s) => s.id != null)
        .map((s) => s.id!)
        .toList();

    if (_selected.id == null && workerIds.isEmpty) {
      _showMessage('Нет сотрудников для выбранного филиала');
      return;
    }

    setState(() => _isSubmitting = true);
    final service = ref.read(settingsServiceProvider);

    try {
      switch (widget.action) {
        case SettingsWorkerAction.resetAccess:
          if (_selected.id == null) {
            await service.resetWorkersAccess(workerIds: workerIds);
          } else {
            await service.resetWorkerAccess(workerId: _selected.id!);
          }
        case SettingsWorkerAction.prohibitOnlineBooking:
          if (_selected.id == null) {
            await service.prohibitOnlineBookingForWorkers(
              workerIds: workerIds,
            );
          } else {
            await service.prohibitOnlineBooking(workerId: _selected.id!);
          }
      }

      if (!mounted) return;
      ref.invalidate(scheduleWorkersProvider);
      ref.invalidate(settingsPickerWorkersProvider(widget.action));
      Navigator.of(context).pop();
      _showMessage(
        widget.action.successMessage,
        variant: AppServiceMessageVariant.success,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage(
        _settingsActionErrorMessage(e),
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(
    String text, {
    AppServiceMessageVariant variant = AppServiceMessageVariant.success,
  }) {
    showAppServiceMessage(context, message: text, variant: variant);
  }

  String _settingsActionErrorMessage(Object error) {
    final actionError = _unwrapSettingsActionException(error);
    if (actionError != null) return actionError.message;

    final statusCode = _extractHttpStatusCode(error);
    if (statusCode == 403) {
      return 'Недостаточно прав для этого действия.';
    }
    return 'Не удалось выполнить действие. Попробуйте позже.';
  }

  SettingsActionException? _unwrapSettingsActionException(Object error) {
    if (error is SettingsActionException) return error;
    if (error is CustomException) {
      final caused = error.causedError;
      if (caused is SettingsActionException) return caused;
    }
    return null;
  }

  int? _extractHttpStatusCode(Object error) {
    Object? current = error;
    for (var depth = 0; depth < 4 && current != null; depth++) {
      if (current is DioException) {
        return current.response?.statusCode;
      }
      if (current is CustomException) {
        current = current.causedError;
        continue;
      }
      break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final listSurface =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final primaryText =
        isDark ? AppColors.primaryDarkDark : AppColors.primaryDark;
    final secondaryText = isDark ? AppColors.tabbarGreyDark : AppColors.grey;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.82;

    final workersAsync = ref.watch(settingsPickerWorkersProvider(widget.action));
    final workerLabels =
        ref.watch(workerEntityLabelsProvider).value ??
        WorkerEntityLabels.defaults;

    return Dialog(
      backgroundColor: surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: workersAsync.when(
            loading: () => const SizedBox(
              height: 280,
              child: Center(child: LoadingWidget()),
            ),
            error: (_, __) => _ErrorBody(
              primaryText: primaryText,
              secondaryText: secondaryText,
              onClose: () => Navigator.of(context).pop(),
            ),
            data: (workers) {
              final specialists = _specialistsFromWorkers(workers, workerLabels);
              final filtered = _filter(specialists);
              final selectedIndex = specialists.indexWhere(
                (s) => s.id == _selected.id && s.name == _selected.name,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.action.title,
                          style: AppFonts.h4Medium.copyWith(
                            color: primaryText,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Image.asset(
                          AppImages.closeRounded,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  TextField(
                    controller: _searchController,
                    enabled: !_isSubmitting,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    style: AppFonts.c1Regular.copyWith(color: primaryText),
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      hintStyle:
                          AppFonts.c1Regular.copyWith(color: secondaryText),
                      filled: true,
                      fillColor: listSurface,
                      border: OutlineInputBorder(
                        borderRadius: AppDecoration.borderRadius300,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18,
                                color: secondaryText,
                              ),
                              onPressed: _searchController.clear,
                            ),
                    ),
                  ),
                  const Gap(12),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: listSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                workerLabels.notFound,
                                style: AppFonts.c1Regular.copyWith(
                                  color: secondaryText,
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Gap(12),
                              itemBuilder: (context, index) {
                                final s = filtered[index];
                                final originalIndex = specialists.indexWhere(
                                  (e) =>
                                      e.id == s.id && e.name == s.name,
                                );
                                return InkWell(
                                  onTap: _isSubmitting
                                      ? null
                                      : () => setState(() => _selected = s),
                                  child: Row(
                                    children: [
                                      if (s.id != null) ...[
                                        _WorkerAvatarPlaceholder(
                                          pictureUrl: s.pictureUrl,
                                          name: s.name,
                                        ),
                                        const Gap(6),
                                      ],
                                      Expanded(
                                        child: Text(
                                          s.name,
                                          style: AppFonts.c1Regular.copyWith(
                                            color: primaryText,
                                          ),
                                        ),
                                      ),
                                      AppRadio(
                                        value: originalIndex,
                                        groupValue: selectedIndex,
                                        onChanged: _isSubmitting
                                            ? null
                                            : (_) => setState(
                                                  () => _selected = s,
                                                ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => _onConfirm(specialists),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: surface,
                        foregroundColor: AppColors.red,
                        disabledForegroundColor: AppColors.grey,
                        side: BorderSide(
                          color: isDark
                              ? AppColors.secondaryDarkDark
                              : AppColors.secondaryDark,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDecoration.borderRadius300,
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.action.confirmLabel,
                              style: AppFonts.b2Semi.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.primaryText,
    required this.secondaryText,
    required this.onClose,
  });

  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onClose,
            child: Image.asset(AppImages.closeRounded, color: secondaryText),
          ),
        ),
        const Gap(24),
        Text(
          'Не удалось загрузить список сотрудников',
          textAlign: TextAlign.center,
          style: AppFonts.b2Medium.copyWith(color: primaryText),
        ),
        const Gap(24),
      ],
    );
  }
}

class _WorkerAvatarPlaceholder extends StatelessWidget {
  const _WorkerAvatarPlaceholder({
    required this.name,
    this.pictureUrl,
  });

  final String name;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _emptyCircle(isDark),
        ),
      );
    }
    return _emptyCircle(isDark);
  }

  Widget _emptyCircle(bool isDark) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.primaryWhiteDark : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark,
        ),
      ),
    );
  }
}
