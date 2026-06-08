import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/create/data/models/clients_api.dart';
import 'package:rient_app/features/create/data/models/worker_services_api.dart';
import 'package:rient_app/features/create/service/clients_service.dart';
import 'package:rient_app/features/create/view/components/client_arrived_payment_confirm_dialog.dart';
import 'package:rient_app/features/create/view/components/client_status_selector_widget.dart';
import 'package:rient_app/features/link/service/widget_links_service.dart';
import 'package:rient_app/features/create/view/providers/clients_provider.dart';
import 'package:rient_app/features/create/view/providers/worker_services_provider.dart';
import 'package:rient_app/features/create/view/providers/workers_offering_catalog_services_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/view/providers/worker_schedules_range_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/resources/resources.dart';

DateTime _dateOnlyForScheduleStats(DateTime d) =>
    DateTime(d.year, d.month, d.day);

/// Инвалидация загруженности (статистика недели/месяца) для календарного дня.
void _invalidateScheduleStatsForDayWidgetRef(WidgetRef ref, DateTime localDay) {
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
}

void _invalidateScheduleStatsForDayContainer(
  ProviderContainer container,
  DateTime localDay,
) {
  container.invalidate(scheduleStatisticsForWeekProvider);
  container.invalidate(scheduleStatisticsForMonthProvider);
}

/// После переноса записи — обновить статистику для нового и (если отличается) старого дня.
void _invalidateScheduleStatsForDateMoveWidgetRef(
  WidgetRef ref,
  DateTime newLocal,
  DateTime? oldLocal,
) {
  _invalidateScheduleStatsForDayWidgetRef(ref, newLocal);
  if (oldLocal != null) {
    final newD = _dateOnlyForScheduleStats(newLocal);
    final oldD = _dateOnlyForScheduleStats(oldLocal);
    if (oldD != newD) {
      _invalidateScheduleStatsForDayWidgetRef(ref, oldLocal);
    }
  }
}

// Тема как на главной: фон экрана и поверхности.
bool _entryIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _entryScaffoldBg(BuildContext context) => _entryIsDark(context)
    ? AppColors.secondaryDarkLight
    : AppColors.tabBarScreenBackground;

/// «Белые» карточки: в тёмной теме — primaryWhiteDark, в светлой — primaryWhite.
Color _entryCardSurface(BuildContext context) =>
    _entryIsDark(context) ? AppColors.primaryWhiteDark : AppColors.primaryWhite;

Color _entryAppBarSurface(BuildContext context) =>
    _entryIsDark(context) ? AppColors.primaryWhiteDark : Colors.white;

/// Вложенные контейнеры на карточках: в тёмной теме — secondaryDarkLight.
Color _entryMutedFill(BuildContext context) => _entryIsDark(context)
    ? AppColors.secondaryDarkLight
    : AppColors.secondaryLight;

Color _entryDivider(BuildContext context) => _entryIsDark(context)
    ? AppColors.tetriaryLightDark
    : AppColors.tetriaryLight;

Color _entryAccent(BuildContext context) => AppColors.themeAccent(context);

/// Для списка клиентов при отсутствии права `see_contact_data`: последние 4 цифры
/// номера заменяются на `****` (остальной формат сохраняется).
String _maskPhoneLastFourDigitsForList(String phone) {
  if (phone.isEmpty) return phone;
  var digitCount = 0;
  int? maskStartIndex;
  for (var i = phone.length - 1; i >= 0; i--) {
    final c = phone.codeUnitAt(i);
    final isDigit = c >= 0x30 && c <= 0x39;
    if (isDigit) {
      digitCount++;
      if (digitCount == 4) {
        maskStartIndex = i;
        break;
      }
    }
  }
  if (maskStartIndex == null) {
    return digitCount > 0 ? '****' : phone;
  }
  return '${phone.substring(0, maskStartIndex)}****';
}

/// Пока в поле отображается номер с `****`, обычная маска не должна вырезать звёздочки.
final _passthroughPhoneMaskFormatter = _PassthroughPhoneFormatter();

Color _entryPrimaryText(BuildContext context) =>
    _entryIsDark(context) ? AppColors.primaryDarkDark : AppColors.primaryDark;

final createEntryTotalPriceProvider = StateProvider<double>((ref) => 0);
final createEntryDiscountProvider = StateProvider<double>((ref) => 0);
final createEntryCanSaveProvider = StateProvider<bool>((ref) => false);
final createEntrySavingProvider = StateProvider<bool>((ref) => false);
final createEntryDraftProvider = StateProvider<_CreateAppointmentDraft?>(
  (ref) => null,
);
const _rememberedClientStorageKey = 'create_entry_remembered_client';

class _CreateAppointmentDraft {
  const _CreateAppointmentDraft({
    required this.appointmentId,
    required this.commentId,
    required this.clientId,
    required this.workerId,
    required this.branchId,
    required this.status,
    required this.commentText,
    required this.totalSum,
    required this.discountPercent,
    required this.services,
    required this.startDateTime,
    required this.clientPhone,
    required this.clientFirstName,
    required this.clientLastName,
    required this.clientCommentText,
    required this.shouldCreateClient,
  });

  final int? appointmentId;
  final int? commentId;
  final int? clientId;
  final int workerId;
  final int branchId;
  final int status;
  final String commentText;
  final double totalSum;
  final int discountPercent;
  final List<_CreateAppointmentServiceDraft> services;
  final DateTime startDateTime;
  final String clientPhone;
  final String clientFirstName;
  final String clientLastName;
  final String clientCommentText;
  final bool shouldCreateClient;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _CreateAppointmentDraft &&
            other.appointmentId == appointmentId &&
            other.commentId == commentId &&
            other.clientId == clientId &&
            other.workerId == workerId &&
            other.branchId == branchId &&
            other.status == status &&
            other.commentText == commentText &&
            other.totalSum == totalSum &&
            other.discountPercent == discountPercent &&
            other.startDateTime == startDateTime &&
            other.clientPhone == clientPhone &&
            other.clientFirstName == clientFirstName &&
            other.clientLastName == clientLastName &&
            other.clientCommentText == clientCommentText &&
            other.shouldCreateClient == shouldCreateClient &&
            listEquals(other.services, services));
  }

  @override
  int get hashCode => Object.hash(
    appointmentId,
    commentId,
    clientId,
    workerId,
    branchId,
    status,
    commentText,
    totalSum,
    discountPercent,
    startDateTime,
    clientPhone,
    clientFirstName,
    clientLastName,
    clientCommentText,
    shouldCreateClient,
    Object.hashAll(services),
  );

  Map<String, dynamic> toRequestBody({int? overrideClientId}) {
    return {
      'id': appointmentId,
      'client': overrideClientId ?? clientId,
      'comment': {'id': commentId, 'user': null, 'text': commentText},
      'services': services.map((service) => service.toJson()).toList(),
      'worker': workerId,
      'status': status,
      'datetime': startDateTime.toUtc().toIso8601String(),
      'discount': discountPercent,
      'sum': totalSum,
      'paid': false,
      'pay_due': totalSum,
      'has_edited_services': false,
      'branch': branchId,
      'captcha': 'dummy',
    };
  }

  Map<String, dynamic> toUpdateRequestBody({int? overrideClientId}) {
    return {
      'services': services.map((service) => service.toJson()).toList(),
      'status': status,
      'comment': {'id': commentId, 'user': null, 'text': commentText},
      'worker': workerId,
      'branch': branchId,
      'client': overrideClientId ?? clientId,
    };
  }
}

class _CreateAppointmentServiceDraft {
  const _CreateAppointmentServiceDraft({
    this.appointmentServiceId,
    required this.serviceId,
    required this.dateTime,
    required this.durationMinutes,
    required this.addDurationMinutes,
    required this.price,
  });

  final int? appointmentServiceId;
  final int serviceId;
  final DateTime dateTime;
  final int durationMinutes;
  final int addDurationMinutes;
  final double price;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _CreateAppointmentServiceDraft &&
            other.appointmentServiceId == appointmentServiceId &&
            other.serviceId == serviceId &&
            other.dateTime == dateTime &&
            other.durationMinutes == durationMinutes &&
            other.addDurationMinutes == addDurationMinutes &&
            other.price == price);
  }

  @override
  int get hashCode => Object.hash(
    appointmentServiceId,
    serviceId,
    dateTime,
    durationMinutes,
    addDurationMinutes,
    price,
  );

  Map<String, dynamic> toJson() {
    return {
      if (appointmentServiceId != null) 'id': appointmentServiceId,
      'duration': durationMinutes,
      'price': price,
      'add_duration': addDurationMinutes,
      'datetime': dateTime.toUtc().toIso8601String(),
      'service': serviceId,
    };
  }
}

class AddNewEntryInitialData {
  const AddNewEntryInitialData({this.startDateTime, this.workerId});

  final DateTime? startDateTime;
  final int? workerId;
}

class AddNewEntryPage extends ConsumerWidget {
  const AddNewEntryPage({
    super.key,
    this.initialAppointment,
    this.isEditMode = false,
    this.initialData,
  });

  static const name = 'add_new_entry_page';
  static const path = '/add_new_entry_page';
  final AppointmentApi? initialAppointment;
  final bool isEditMode;
  final AddNewEntryInitialData? initialData;

  void _invalidateScheduleCaches(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    final selectedDate = container.read(selectedScheduleDateProvider);
    final normalizedSelected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final days = <DateTime>{normalizedSelected};
    final draft = container.read(createEntryDraftProvider);
    if (draft != null) {
      final s = draft.startDateTime;
      days.add(DateTime(s.year, s.month, s.day));
    }

    container.invalidate(scheduleAppointmentsProvider);
    for (final d in days) {
      _invalidateScheduleStatsForDayContainer(container, d);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('Удалить запись?', style: AppFonts.h4Medium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вы уверены, что хотите удалить данную запись?',
                  style: AppFonts.b2Medium,
                ),
                const Gap(16),
                MainButton(
                  title: 'Удалить',
                  isLoading: isDeleting,
                  isActive: !isDeleting,
                  onTap: () async {
                    if (isDeleting) return;
                    final appointmentId = initialAppointment?.id;
                    if (appointmentId == null) {
                      Navigator.of(dialogContext).pop();
                      return;
                    }

                    setDialogState(() => isDeleting = true);
                    try {
                      await ProviderScope.containerOf(
                            dialogContext,
                            listen: false,
                          )
                          .read(appointmentsServiceProvider)
                          .deleteAppointment(appointmentId: appointmentId);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                      if (context.mounted) {
                        final container = ProviderScope.containerOf(
                          context,
                          listen: false,
                        );
                        container.invalidate(scheduleAppointmentsProvider);
                        DateTime? appointmentDay;
                        final raw = initialAppointment?.datetime;
                        if (raw != null && raw.trim().isNotEmpty) {
                          final p = DateTime.tryParse(raw);
                          if (p != null) {
                            final loc = p.toLocal();
                            appointmentDay = DateTime(
                              loc.year,
                              loc.month,
                              loc.day,
                            );
                          }
                        }
                        final stripDate = container.read(
                          selectedScheduleDateProvider,
                        );
                        final stripDay = DateTime(
                          stripDate.year,
                          stripDate.month,
                          stripDate.day,
                        );
                        final daysToRefresh = <DateTime>{
                          stripDay,
                          if (appointmentDay != null) appointmentDay,
                        };
                        for (final d in daysToRefresh) {
                          _invalidateScheduleStatsForDayContainer(container, d);
                        }
                        final daysToRetry = List<DateTime>.from(daysToRefresh);
                        unawaited(
                          Future<void>.delayed(
                            const Duration(milliseconds: 550),
                            () {
                              for (final d in daysToRetry) {
                                _invalidateScheduleStatsForDayContainer(
                                  container,
                                  d,
                                );
                              }
                            },
                          ),
                        );
                        showAppServiceMessage(
                          context,
                          message: 'Запись удалена',
                        );
                        context.pop(true);
                      }
                    } catch (_) {
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                      if (context.mounted) {
                        showAppServiceMessage(
                          context,
                          message: 'Не удалось удалить запись',
                          variant: AppServiceMessageVariant.error,
                        );
                      }
                    } finally {
                      if (dialogContext.mounted) {
                        setDialogState(() => isDeleting = false);
                      }
                    }
                  },
                  color: const Color(0xff787880).withValues(alpha: 0.16),
                  textColor: AppColors.red,
                ),
                const Gap(8),
                MainButton(
                  title: 'Закрыть',
                  onTap: () => Navigator.of(dialogContext).pop(),
                  isActive: !isDeleting,
                  color: const Color(0xff787880).withValues(alpha: 0.16),
                  textColor: _entryPrimaryText(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _rememberClientFromBody(
    GlobalKey<_BodyWidgetState> bodyKey,
  ) async {
    await bodyKey.currentState?.rememberClient();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyKey = GlobalKey<_BodyWidgetState>();
    final appBarSurface = _entryAppBarSurface(context);
    final cardSurface = _entryCardSurface(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final permissions = ref.watch(workerPermissionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final canDeleteSchedule = permissions?.deleteSchedule ?? true;
    final isScheduleOffline = ref.watch(scheduleOfflineModeProvider);
    final noConnection = ref.watch(appNoConnectionProvider);
    final viewOnly = isScheduleOffline && initialAppointment != null;
    final offlineNewEntryBlocked =
        initialAppointment == null && (noConnection || isScheduleOffline);
    if (offlineNewEntryBlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed(SchedulePage.name);
        }
      });
      return Scaffold(
        backgroundColor: _entryScaffoldBg(context),
        body: const SizedBox.shrink(),
      );
    }
    return Scaffold(
      backgroundColor: _entryScaffoldBg(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: appBarSurface,
        surfaceTintColor: appBarSurface,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                _invalidateScheduleCaches(context);
                context.pop(true);
              },
              child: Image.asset(
                _entryIsDark(context)
                    ? AppImages.backButtonDark
                    : AppImages.back,
              ),
            ),
            Text(
              viewOnly
                  ? 'Просмотр записи'
                  : isEditMode || initialAppointment != null
                  ? 'Редактирование записи'
                  : 'Новая запись',
              style: AppFonts.h4Medium.copyWith(
                color: _entryPrimaryText(context),
              ),
            ),
            if (!viewOnly)
              PopupMenuButton<String>(
                color: cardSurface,
                elevation: 4,
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'remember') {
                    unawaited(_rememberClientFromBody(bodyKey));
                  }
                  if (value == 'delete' &&
                      canDeleteSchedule &&
                      (isEditMode || initialAppointment != null)) {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'remember',
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Запомнить клиента', style: AppFonts.b2Medium),
                  ),
                  if (canDeleteSchedule &&
                      (isEditMode || initialAppointment != null))
                    PopupMenuItem<String>(
                      value: 'delete',
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Удалить',
                        style: AppFonts.b2Medium.copyWith(color: AppColors.red),
                      ),
                    ),
                ],
                child: Image.asset(isDark ? AppImages.moreDark : AppImages.more),
              )
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
      body: _BodyWidget(
          key: bodyKey,
          viewOnly: viewOnly,
          initialAppointment: initialAppointment,
          initialData: initialData,
        ),
      bottomNavigationBar: viewOnly
          ? null
          : _BottomActionsBar(
              isEditMode: isEditMode || initialAppointment != null,
              initialAppointmentId: initialAppointment?.id,
              initialAppointmentDatetime: initialAppointment?.datetime,
            ),
    );
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget({
    super.key,
    this.viewOnly = false,
    this.initialAppointment,
    this.initialData,
  });

  final bool viewOnly;
  final AppointmentApi? initialAppointment;
  final AddNewEntryInitialData? initialData;

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _EntryDatePickerPredicateCache {
  const _EntryDatePickerPredicateCache({
    required this.specialistId,
    required this.branchId,
    required this.predicate,
  });

  final int specialistId;
  final int branchId;
  final bool Function(DateTime day) predicate;
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  bool _isCommentVisitExpanded = false;
  bool _isCommentClientExpanded = false;
  bool _showClientSuggestions = false;
  ClientItem? _selectedClient;
  String _phoneSearchQuery = '';
  final _commentVisitController = TextEditingController();
  final _commentClientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _specialistDropdownSearchController = TextEditingController();
  final List<_ServiceBlockState> _services = [_ServiceBlockState()];
  final _phoneMaskFormatter = _PhoneMaskFormatter();
  int? _selectedSpecialistId;
  int _selectedStatusIndex = 0;
  DateTime _selectedDate = DateTime.now();
  String? _rememberedClientPhone;
  bool _datePickerInFlight = false;
  _EntryDatePickerPredicateCache? _datePickerPredicateCache;
  Future<void>? _datePickerPredicatePrefetch;

  @override
  void initState() {
    super.initState();
    _applyInitialAppointment();
    _applyInitialDataForNewEntry();
    unawaited(_applyRememberedClientForNewEntry());
    final specialistId = _selectedSpecialistId;
    if (specialistId != null) {
      _prefetchDatePickerPredicate(specialistId);
    }
  }

  String _effectiveClientPhoneForSubmit(bool canSeeContactData) {
    if (!canSeeContactData && _selectedClient != null) {
      return _selectedClient!.phone.trim();
    }
    return _phoneController.text.trim();
  }

  void _syncPhoneFieldForSelectedClientPrivacy(bool canSeeContactData) {
    final client = _selectedClient;
    if (client == null || client.phone.isEmpty) return;
    final full = client.phone;
    final masked = _maskPhoneLastFourDigitsForList(full);
    final target = canSeeContactData ? full : masked;
    if (_phoneController.text == target) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _selectedClient;
      if (c == null || c.phone.isEmpty) return;
      final t = canSeeContactData
          ? c.phone
          : _maskPhoneLastFourDigitsForList(c.phone);
      if (_phoneController.text != t) {
        setState(() {
          _phoneController.text = t;
        });
      }
    });
  }

  Future<void> rememberClient() async {
    final canSeeContactData = ref.read(workerPermissionsProvider).maybeWhen(
          data: (v) => v.seeContactData,
          orElse: () => true,
        );
    final phone = _effectiveClientPhoneForSubmit(canSeeContactData);
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (phone.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      showAppServiceMessage(
        context,
        message: 'Заполните телефон, имя и фамилию клиента',
        variant: AppServiceMessageVariant.info,
      );
      return;
    }

    final payload = <String, dynamic>{
      'id': _selectedClient?.id,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'comment_text': _commentClientController.text.trim(),
      'status': _selectedStatusIndex,
    };
    await ref
        .read(localStorageProvider)
        .saveString(_rememberedClientStorageKey, jsonEncode(payload));
    if (!mounted) return;
    showAppServiceMessage(context, message: 'Клиент запомнен');
  }

  /// Дата записи для формы: по услугам (как в календаре), не только `appointment.datetime`.
  DateTime? _appointmentCalendarDate(AppointmentApi appointment) {
    for (final service in appointment.services) {
      final parsed = DateTime.tryParse(service.datetime ?? '')?.toLocal();
      if (parsed != null) {
        return DateTime(parsed.year, parsed.month, parsed.day);
      }
    }
    final parsed = DateTime.tryParse(appointment.datetime)?.toLocal();
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  bool _isInitialServiceTime(
    AppointmentApi appointment,
    int serviceIndex,
    String selectedTime,
  ) {
    if (serviceIndex < 0 || serviceIndex >= appointment.services.length) {
      return false;
    }
    final service = appointment.services[serviceIndex];
    final serviceDateTime = DateTime.tryParse(service.datetime ?? '')?.toLocal();
    if (serviceDateTime == null) return false;
    return _formatSlot(serviceDateTime) == selectedTime;
  }

  void _applyInitialAppointment() {
    final appointment = widget.initialAppointment;
    if (appointment == null) return;

    _selectedSpecialistId = appointment.worker?.id;
    _selectedStatusIndex = _statusToIndex(appointment.status);
    _commentVisitController.text = appointment.commentText ?? '';
    if (_commentVisitController.text.trim().isNotEmpty) {
      _isCommentVisitExpanded = true;
    }
    _phoneController.text = appointment.client?.phone ?? '';
    _phoneSearchQuery = _phoneController.text;
    _firstNameController.text = appointment.client?.firstName ?? '';
    _lastNameController.text = appointment.client?.lastName ?? '';
    final initialClient = appointment.client;
    if (initialClient != null) {
      _selectedClient = ClientItem(
        id: initialClient.id,
        firstName: initialClient.firstName ?? '',
        lastName: initialClient.lastName ?? '',
        phone: initialClient.phone ?? '',
        status: 0,
        reliabilityFactor: 0,
        balance: 0,
        numberOfVisits: 0,
        discount: 0,
        transactionsSum: 0,
        commentText: null,
      );
      if (!widget.viewOnly) {
        unawaited(_loadSelectedClientDetails(initialClient.id));
      }
    }

    final calendarDate = _appointmentCalendarDate(appointment);
    if (calendarDate != null) {
      _selectedDate = calendarDate;
    }

    _services
      ..clear()
      ..addAll(
        appointment.services.isEmpty
            ? [_ServiceBlockState()]
            : appointment.services.map(_createInitialServiceBlock),
      );
  }

  void _applyInitialDataForNewEntry() {
    if (widget.initialAppointment != null) return;
    final initialData = widget.initialData;
    if (initialData == null) return;
    final startDateTime = initialData.startDateTime;
    if (startDateTime != null) {
      final local = startDateTime.toLocal();
      _selectedDate = DateTime(local.year, local.month, local.day);
      final h = local.hour.toString().padLeft(2, '0');
      final m = local.minute.toString().padLeft(2, '0');
      _services.first.selectedTime = '$h:$m';
    }
    if (initialData.workerId != null) {
      _selectedSpecialistId = initialData.workerId;
    }
  }

  Future<void> _applyRememberedClientForNewEntry() async {
    if (widget.initialAppointment != null) return;
    final raw = await ref
        .read(localStorageProvider)
        .getString(_rememberedClientStorageKey);
    if (raw == null || raw.isEmpty || !mounted) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final phone = (json['phone'] as String? ?? '').trim();
      final firstName = (json['first_name'] as String? ?? '').trim();
      final lastName = (json['last_name'] as String? ?? '').trim();
      final commentText = (json['comment_text'] as String? ?? '').trim();
      final status = (json['status'] as num?)?.toInt() ?? 0;
      final id = (json['id'] as num?)?.toInt();
      if (phone.isEmpty || firstName.isEmpty || lastName.isEmpty) return;
      setState(() {
        _rememberedClientPhone = phone;
        _phoneController.text = phone;
        _phoneSearchQuery = phone;
        _showClientSuggestions = false;
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _commentClientController.text = commentText;
        if (commentText.isNotEmpty) {
          _isCommentClientExpanded = true;
        }
        _selectedStatusIndex = status;
        _selectedClient = ClientItem(
          id: id ?? 0,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          status: status,
          reliabilityFactor: 0,
          balance: 0,
          numberOfVisits: 0,
          discount: 0,
          transactionsSum: 0,
          commentText: commentText.isEmpty ? null : commentText,
        );
      });
    } catch (_) {
      // Ignore broken storage payload.
    }
  }

  void _ensureSpecialistLockedToCurrentWorker(int workerId) {
    if (workerId <= 0) return;
    if (_selectedSpecialistId == workerId) return;
    setState(() {
      final hadDifferent =
          _selectedSpecialistId != null && _selectedSpecialistId != workerId;
      _selectedSpecialistId = workerId;
      if (hadDifferent) {
        for (final service in _services) {
          service.selectedServiceId = null;
          service.durationMinutes = 10;
          service.addDurationMinutes = 0;
          service.selectedTime = null;
        }
      }
    });
    _resetDatePickerPredicateCache();
    _prefetchDatePickerPredicate(workerId);
  }

  void _resetDatePickerPredicateCache() {
    _datePickerPredicateCache = null;
    _datePickerPredicatePrefetch = null;
  }

  void _prefetchDatePickerPredicate(int specialistId) {
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId == 0) return;
    _datePickerPredicatePrefetch = _buildDateSelectablePredicate(
      specialistId: specialistId,
      branchId: branchId,
    ).then((predicate) {
      if (predicate == null || !mounted) return;
      _datePickerPredicateCache = _EntryDatePickerPredicateCache(
        specialistId: specialistId,
        branchId: branchId,
        predicate: predicate,
      );
    });
  }

  void _onSpecialistChanged(int? value) {
    setState(() {
      _selectedSpecialistId = value;
      for (final service in _services) {
        service.selectedServiceId = null;
        service.durationMinutes = 10;
        service.addDurationMinutes = 0;
        service.selectedTime = null;
      }
    });
    _resetDatePickerPredicateCache();
    if (value != null) {
      _prefetchDatePickerPredicate(value);
    }
  }

  /// `null` — не открывать календарь (ошибка или уже показали сообщение).
  Future<bool Function(DateTime day)?> _buildDateSelectablePredicate({
    required int specialistId,
    required int branchId,
  }) async {
    try {
      final workerRow = await ref
          .read(workersServiceProvider)
          .getWorkerRow(workerId: specialistId, branchId: branchId);
      final scheduleConfig = workerScheduleConfigForBranch(
        workerRow,
        branchId,
      );
      if (isShiftWorkerScheduleConfig(scheduleConfig)) {
        return (day) => isShiftWorkerWorkDay(
          _dateOnly(day),
          scheduleConfig,
        );
      }

      final allowedWeekdays = await _loadSpecialistWorkingWeekdays(
        specialistId: specialistId,
        branchId: branchId,
      );
      if (allowedWeekdays.isEmpty) {
        if (mounted) {
          showAppServiceMessage(
            context,
            message: 'У выбранного мастера нет рабочих дней',
            variant: AppServiceMessageVariant.info,
          );
        }
        return null;
      }

      final from = _dateOnly(_selectedDate).subtract(const Duration(days: 60));
      final to = _dateOnly(_selectedDate).add(const Duration(days: 400));
      final schedulesResponse = await ref
          .read(schedulesServiceProvider)
          .getWorkerSchedules(
            workerId: specialistId,
            dateGte: from,
            dateLte: to,
          );
      final schedulesByDate = indexDailySchedulesByDate(
        schedulesResponse.results,
      );
      return (day) {
        final normalized = _dateOnly(day);
        return isWorkerWorkingOnDate(
          date: normalized,
          workingWeekdays: allowedWeekdays,
          daily: schedulesByDate[SchedulesService.dateToApi(normalized)],
          shiftConfig: scheduleConfig,
        );
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearRememberedClientIfChanged(String nextPhone) async {
    final rememberedPhone = _rememberedClientPhone;
    if (rememberedPhone == null) return;
    if (nextPhone.trim() == rememberedPhone.trim()) return;
    _rememberedClientPhone = null;
    await ref
        .read(localStorageProvider)
        .removeValue(_rememberedClientStorageKey);
  }

  Future<void> _loadSelectedClientDetails(int clientId) async {
    try {
      final response = await ref
          .read(clientsServiceProvider)
          .getClients(search: _phoneSearchQuery);
      ClientItem? fullClient;
      for (final item in response.results) {
        if (item.id == clientId) {
          fullClient = item;
          break;
        }
      }
      if (fullClient == null || !mounted) return;
      setState(() {
        _selectedClient = fullClient;
        final clientComment = fullClient!.commentText ?? '';
        _commentClientController.text = clientComment;
        if (clientComment.trim().isNotEmpty) {
          _isCommentClientExpanded = true;
        }
      });
    } catch (_) {
      // Игнорируем ошибку подгрузки деталей: форма редактирования должна оставаться рабочей.
    }
  }

  int _statusToIndex(int status) {
    if (status < 0) return 1;
    if (status > 4) return 4;
    return status;
  }

  Future<void> _onClientStatusSelected(int index) async {
    if (index == kClientArrivedStatusIndex &&
        _selectedStatusIndex != kClientArrivedStatusIndex) {
      final appointmentId = widget.initialAppointment?.id;
      if (appointmentId != null && appointmentId > 0) {
        final result = await showClientArrivedPaymentConfirmDialog(
          context: context,
          appointmentId: appointmentId,
        );
        if (!mounted) return;
        switch (result) {
          case ClientArrivedPaymentDialogResult.pay:
            setState(() => _selectedStatusIndex = kClientArrivedStatusIndex);
            await _openAppointmentPayment(appointmentId);
          case ClientArrivedPaymentDialogResult.saveOnly:
            setState(() => _selectedStatusIndex = kClientArrivedStatusIndex);
          case ClientArrivedPaymentDialogResult.dismiss:
          case null:
            break;
        }
        return;
      }
    }
    setState(() => _selectedStatusIndex = index);
  }

  Future<void> _openAppointmentPayment(int appointmentId) async {
    try {
      final url = await ref
          .read(widgetLinksServiceProvider)
          .getAppointmentPaymentWidgetUrl(appointmentId: appointmentId);
      final uri = Uri.tryParse(url);
      if (uri == null) {
        if (!mounted) return;
        showAppServiceMessage(
          context,
          message: 'Не удалось открыть оплату',
          variant: AppServiceMessageVariant.error,
        );
        return;
      }
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        showAppServiceMessage(
          context,
          message: 'Не удалось открыть оплату',
          variant: AppServiceMessageVariant.error,
        );
      }
    } catch (_) {
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: 'Не удалось загрузить ссылку на оплату',
        variant: AppServiceMessageVariant.error,
      );
    }
  }

  _ServiceBlockState _createInitialServiceBlock(AppointmentServiceApi service) {
    final block = _ServiceBlockState();
    final serviceName = (service.name ?? '').trim();
    final serviceDateTime = DateTime.tryParse(
      service.datetime ?? '',
    )?.toLocal();

    if (serviceName.isNotEmpty) {
      block.initialServiceName = serviceName;
    }
    block.isTimeExpanded = true;
    block.appointmentServiceId = service.id;
    if (service.serviceId != null) {
      block.selectedServiceId = service.serviceId;
    }
    if (serviceDateTime != null) {
      final h = serviceDateTime.hour.toString().padLeft(2, '0');
      final m = serviceDateTime.minute.toString().padLeft(2, '0');
      block.selectedTime = '$h:$m';
    }
    final totalMinutes = service.totalDurationMinutes;
    if (service.duration >= 0) {
      block.durationMinutes = service.duration;
    }
    if (service.addDuration >= 0) {
      block.addDurationMinutes = service.addDuration;
    } else if (totalMinutes >= 0) {
      // Fallback для старых ответов, где доступна только сумма.
      block.durationMinutes = totalMinutes;
      block.addDurationMinutes = 0;
    }

    return block;
  }

  @override
  void dispose() {
    _commentVisitController.dispose();
    _commentClientController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specialistDropdownSearchController.dispose();
    for (final service in _services) {
      service.serviceSearchController.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  List<Widget> _viewOnlyMasterServicesChildren({
    required Color mutedFill,
    required Color divider,
    required Color primaryText,
    required Color accent,
    required WorkerEntityLabels workerLabels,
    required bool isWorkerRole,
  }) {
    final worker = widget.initialAppointment?.worker;
    final workerName = worker == null
        ? '—'
        : '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim();

    return [
      Text(workerLabels.sectionAndServices, style: AppFonts.b1Medium),
      const Gap(16),
      Text(
        workerLabels.workerFieldLabel(isWorkerRole: isWorkerRole),
        style: AppFonts.c1Medium,
      ),
      const Gap(8),
      DefaultContainerWidget(
        color: mutedFill,
        borderRadius: BorderRadius.circular(300),
        hasShadow: false,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          workerName.isEmpty ? '—' : workerName,
          style: AppFonts.c1Regular.copyWith(color: primaryText),
        ),
      ),
      const Gap(16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Дата', style: AppFonts.c1Medium),
          Text(
            _formatDate(_selectedDate),
            style: AppFonts.c1Regular.copyWith(color: primaryText),
          ),
        ],
      ),
      for (var index = 0; index < _services.length; index++) ...[
        Divider(height: 32, color: divider),
        Text('Услуга ${index + 1}', style: AppFonts.c1Medium),
        const Gap(12),
        DefaultContainerWidget(
          color: mutedFill,
          borderRadius: BorderRadius.circular(16),
          hasShadow: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            (_services[index].initialServiceName ?? '').trim().isNotEmpty
                ? _services[index].initialServiceName!.trim()
                : 'Услуга',
            style: AppFonts.c1Regular.copyWith(color: primaryText),
          ),
        ),
        if ((_services[index].selectedTime ?? '').isNotEmpty) ...[
          const Gap(8),
          Text(
            'Время: ${_services[index].selectedTime}',
            style: AppFonts.c1Regular.copyWith(color: accent),
          ),
        ],
        if (_services[index].totalDurationMinutes > 0) ...[
          const Gap(4),
          Text(
            'Длительность: ${_services[index].totalDurationMinutes} мин',
            style: AppFonts.c2Tabbar.copyWith(color: AppColors.grey),
          ),
        ],
      ],
    ];
  }

  String _formatMoney(double value) => '${value.round()}₽';

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime? _dateTimeFromTimeOfDayString({
    required DateTime date,
    required String? value,
  }) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String _formatSlot(DateTime dateTime) {
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  int _slotGridStepMinutes(int durationMinutes) {
    if (durationMinutes <= 0) return 10;
    if (durationMinutes <= 10) return durationMinutes;
    return 10;
  }

  List<_DateTimeRange> _busyRangesFromAppointments(
    List<AppointmentApi> appointments, {
    int? ignoreAppointmentId,
  }) {
    final result = <_DateTimeRange>[];
    for (final appointment in appointments) {
      if (!appointment.isActive) continue;
      if (ignoreAppointmentId != null &&
          appointment.id == ignoreAppointmentId) {
        continue;
      }
      if (appointment.services.isEmpty) continue;
      for (final service in appointment.services) {
        final serviceStart = appointment.resolveServiceStartLocal(service);
        final serviceEnd = appointment.resolveServiceEndLocal(service);
        if (serviceEnd.isAfter(serviceStart)) {
          result.add(_DateTimeRange(start: serviceStart, end: serviceEnd));
        }
      }
    }
    return result;
  }

  bool _isRangeFree({
    required DateTime start,
    required DateTime end,
    required List<_DateTimeRange> busyRanges,
  }) {
    for (final busy in busyRanges) {
      final overlaps = start.isBefore(busy.end) && end.isAfter(busy.start);
      if (overlaps) return false;
    }
    return true;
  }

  List<String> _availableSlotsForService({
    required DateTime date,
    required int durationMinutes,
    required AvailableWorkerShift? shift,
    ScheduleItemApi? daily,
    required List<AppointmentApi> appointments,
    required int currentServiceIndex,
  }) {
    final editingAppointment = widget.initialAppointment;
    final currentTime = currentServiceIndex >= 0 &&
            currentServiceIndex < _services.length
        ? _services[currentServiceIndex].selectedTime
        : null;

    if (shift == null || durationMinutes <= 0) {
      if (editingAppointment != null &&
          currentTime != null &&
          currentTime.isNotEmpty) {
        return [currentTime];
      }
      return const <String>[];
    }
    final shiftBounds = resolveWorkerShiftBoundsForDate(
      daily: daily,
      fallbackTimeStart: shift.timeStart,
      fallbackTimeEnd: shift.timeEnd,
    );
    final shiftStart = _dateTimeFromTimeOfDayString(
      date: date,
      value: shiftBounds.timeStart,
    );
    final shiftEnd = _dateTimeFromTimeOfDayString(
      date: date,
      value: shiftBounds.timeEnd,
    );
    if (shiftStart == null ||
        shiftEnd == null ||
        !shiftEnd.isAfter(shiftStart)) {
      return const <String>[];
    }

    final busyRanges = <_DateTimeRange>[
      ..._busyRangesFromAppointments(
        appointments,
        ignoreAppointmentId: widget.initialAppointment?.id,
      ),
    ];
    // Перерыв в календаре только визуальный (ячейки под ним кликабельны).
    // Слоты блокируем записями и другими услугами в этой форме, не break_start/end.
    for (var i = 0; i < _services.length; i++) {
      if (i == currentServiceIndex) continue;
      final block = _services[i];
      final selectedTime = block.selectedTime;
      if (selectedTime == null || selectedTime.isEmpty) continue;
      final blockStart = _dateTimeFromTimeOfDayString(
        date: date,
        value: selectedTime,
      );
      if (blockStart == null) continue;
      final blockDuration = block.totalDurationMinutes <= 0
          ? 10
          : block.totalDurationMinutes;
      final blockEnd = blockStart.add(Duration(minutes: blockDuration));
      if (!blockEnd.isAfter(blockStart)) continue;
      busyRanges.add(_DateTimeRange(start: blockStart, end: blockEnd));
    }

    final slots = <String>[];
    final now = DateTime.now();
    final isToday = _dateOnly(date) == _dateOnly(now);
    var cursor = shiftStart;
    final slotStepMinutes = _slotGridStepMinutes(durationMinutes);
    while (!cursor.add(Duration(minutes: durationMinutes)).isAfter(shiftEnd)) {
      final slotEnd = cursor.add(Duration(minutes: durationMinutes));
      if (isToday && cursor.isBefore(now)) {
        cursor = cursor.add(Duration(minutes: slotStepMinutes));
        continue;
      }
      if (_isRangeFree(start: cursor, end: slotEnd, busyRanges: busyRanges)) {
        slots.add(_formatSlot(cursor));
      }
      cursor = cursor.add(Duration(minutes: slotStepMinutes));
    }

    if (currentTime != null &&
        currentTime.isNotEmpty &&
        !slots.contains(currentTime)) {
      final ownStart = _dateTimeFromTimeOfDayString(
        date: date,
        value: currentTime,
      );
      if (ownStart != null) {
        final ownEnd = ownStart.add(Duration(minutes: durationMinutes));
        if (!ownStart.isBefore(shiftStart) &&
            !ownEnd.isAfter(shiftEnd) &&
            _isRangeFree(start: ownStart, end: ownEnd, busyRanges: busyRanges)) {
          slots.add(currentTime);
          slots.sort((a, b) {
            final ah = int.tryParse(a.split(':').first) ?? 0;
            final am = int.tryParse(a.split(':').last) ?? 0;
            final bh = int.tryParse(b.split(':').first) ?? 0;
            final bm = int.tryParse(b.split(':').last) ?? 0;
            if (ah != bh) return ah.compareTo(bh);
            return am.compareTo(bm);
          });
        }
      }
    }

    return slots;
  }

  List<String> _slotsByHourRange(
    List<String> slots, {
    required int fromHourInclusive,
    required int toHourExclusive,
  }) {
    return slots.where((slot) {
      final hour = int.tryParse(slot.split(':').first) ?? -1;
      return hour >= fromHourInclusive && hour < toHourExclusive;
    }).toList();
  }

  AvailableWorkerShift? _shiftForSpecialist(
    List<AvailableWorkerShift> shifts,
    int specialistId,
  ) {
    for (final shift in shifts) {
      if (shift.worker.id == specialistId) return shift;
    }
    return null;
  }

  List<List<String>> _chunkSlots(List<String> slots, int chunkSize) {
    if (slots.isEmpty || chunkSize <= 0) return const [];
    final chunks = <List<String>>[];
    for (var i = 0; i < slots.length; i += chunkSize) {
      final end = (i + chunkSize) > slots.length ? slots.length : i + chunkSize;
      chunks.add(slots.sublist(i, end));
    }
    return chunks;
  }

  Future<Set<int>> _loadSpecialistWorkingWeekdays({
    required int specialistId,
    required int branchId,
  }) async {
    final map = await ref
        .read(workersServiceProvider)
        .getWorkersWorkingWeekdays(branchId: branchId);
    return map[specialistId] ?? const <int>{};
  }

  _CreateAppointmentDraft? _buildCreateDraft({
    required List<WorkerServiceItem> workerServices,
    required int? selectedSpecialistId,
    required int branchId,
    required double totalSum,
    required double selectedClientDiscount,
    required bool canSeeContactData,
  }) {
    if (selectedSpecialistId == null || branchId == 0) {
      return null;
    }

    final completeServices = <_CreateAppointmentServiceDraft>[];
    for (final block in _services) {
      final selectedServiceId = block.selectedServiceId;
      final selectedTime = block.selectedTime;
      if (selectedServiceId == null ||
          selectedTime == null ||
          selectedTime.isEmpty) {
        continue;
      }
      final workerService = _selectedWorkerService(
        workerServices,
        selectedServiceId,
      );
      if (workerService == null) continue;
      final startTime = _dateTimeFromTimeOfDayString(
        date: _dateOnly(_selectedDate),
        value: selectedTime,
      );
      if (startTime == null) continue;
      completeServices.add(
        _CreateAppointmentServiceDraft(
          appointmentServiceId: block.appointmentServiceId,
          serviceId: workerService.id,
          dateTime: startTime,
          durationMinutes: block.durationMinutes <= 0
              ? 10
              : block.durationMinutes,
          addDurationMinutes: block.addDurationMinutes <= 0
              ? 0
              : block.addDurationMinutes,
          price: workerService.price,
        ),
      );
    }

    if (completeServices.isEmpty) return null;
    completeServices.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final effectivePhone =
        _effectiveClientPhoneForSubmit(canSeeContactData).trim();
    final hasRequiredManualClientData =
        effectivePhone.isNotEmpty &&
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty;
    final shouldCreateClient =
        _selectedClient == null && hasRequiredManualClientData;

    return _CreateAppointmentDraft(
      appointmentId: widget.initialAppointment?.id,
      commentId: widget.initialAppointment?.commentId,
      clientId: shouldCreateClient
          ? null
          : (_selectedClient?.id ?? widget.initialAppointment?.client?.id),
      workerId: selectedSpecialistId,
      branchId: branchId,
      status: _selectedStatusIndex,
      commentText: _commentVisitController.text.trim(),
      totalSum: totalSum,
      discountPercent: selectedClientDiscount.round(),
      services: completeServices,
      startDateTime: completeServices.first.dateTime,
      clientPhone: effectivePhone,
      clientFirstName: _firstNameController.text.trim(),
      clientLastName: _lastNameController.text.trim(),
      clientCommentText: _commentClientController.text.trim(),
      shouldCreateClient: shouldCreateClient,
    );
  }

  Widget _buildTimeRows({
    required BuildContext context,
    required List<String> slots,
    required String? selectedTime,
    required ValueChanged<String> onSelect,
    required ValueChanged<String> onLongPressSlot,
  }) {
    final rows = _chunkSlots(slots, 4);
    return Column(
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
          Row(
            children: [
              for (var i = 0; i < rows[rowIndex].length; i++) ...[
                Expanded(
                  child: _buildTimeChip(
                    context,
                    rows[rowIndex][i],
                    isSelected: selectedTime == rows[rowIndex][i],
                    onTap: () => onSelect(rows[rowIndex][i]),
                    onLongPress: () => onLongPressSlot(rows[rowIndex][i]),
                  ),
                ),
                if (i != rows[rowIndex].length - 1) const Gap(8),
              ],
              if (rows[rowIndex].length < 4) ...[
                for (var i = rows[rowIndex].length; i < 4; i++) ...[
                  if (i != 0) const Gap(8),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ],
          ),
          if (rowIndex != rows.length - 1) const Gap(8),
        ],
      ],
    );
  }

  Future<void> _pickDate() async {
    if (_datePickerInFlight) return;
    _datePickerInFlight = true;

    try {
      final specialistId = _selectedSpecialistId;
      final branchId = ref.read(currentBranchIdProvider);

      bool Function(DateTime day)? isSelectableDay;
      if (specialistId != null && branchId != 0) {
        final prefetch = _datePickerPredicatePrefetch;
        if (prefetch != null) {
          await prefetch;
        }
        final cached = _datePickerPredicateCache;
        if (cached != null &&
            cached.specialistId == specialistId &&
            cached.branchId == branchId) {
          isSelectableDay = cached.predicate;
        } else {
          isSelectableDay = await _buildDateSelectablePredicate(
            specialistId: specialistId,
            branchId: branchId,
          );
          if (isSelectableDay == null) return;
          _datePickerPredicateCache = _EntryDatePickerPredicateCache(
            specialistId: specialistId,
            branchId: branchId,
            predicate: isSelectableDay,
          );
        }
      }
      if (!mounted) return;

      final anchor = _dateOnly(_selectedDate);
      final initialDate = isSelectableDay == null
          ? anchor
          : (isSelectableDay(anchor)
              ? anchor
              : resolveNextWorkerWorkDate(
                  from: anchor,
                  isWorkDay: (d) => isSelectableDay!(_dateOnly(d)),
                ));

      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('ru'),
        selectableDayPredicate: (day) {
          if (isSelectableDay == null) return true;
          return isSelectableDay(_dateOnly(day));
        },
      );
      if (picked == null || !mounted) return;
      setState(() => _selectedDate = _dateOnly(picked));
    } finally {
      _datePickerInFlight = false;
    }
  }

  Widget _buildTimeChip(
    BuildContext context,
    String time, {
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 39,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _entryAccent(context) : _entryMutedFill(context),
          borderRadius: BorderRadius.circular(300),
        ),
        child: Text(
          time,
          style: AppFonts.c1Regular.copyWith(
            color: isSelected
                ? AppColors.primaryWhite
                : _entryPrimaryText(context),
          ),
        ),
      ),
    );
  }

  ({int hour, int minute}) _parseTime(String value) {
    final parts = value.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return (hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }

  Future<void> _showManualTimePickerDialog({
    required List<String> availableSlots,
    required String initialTime,
    required ValueChanged<String> onSelect,
  }) async {
    final parsed = _parseTime(initialTime);
    var selectedHour = parsed.hour;
    var selectedMinute = (parsed.minute ~/ 5) * 5;
    final minuteValues = List<int>.generate(12, (i) => i * 5);
    final hourController = FixedExtentScrollController(
      initialItem: selectedHour,
    );
    final minuteController = FixedExtentScrollController(
      initialItem: minuteValues.indexOf(selectedMinute),
    );

    final picked = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (popupContext) {
        final isDark = Theme.of(popupContext).brightness == Brightness.dark;
        final bg = isDark ? AppColors.primaryWhiteDark : AppColors.primaryWhite;
        final textColor = isDark
            ? AppColors.primaryDarkDark
            : AppColors.primaryDark;
        final wheelTextColor = isDark
            ? AppColors.primaryDarkDark
            : AppColors.primaryDark;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final selectedTime =
                '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
            final isAvailable = availableSlots.contains(selectedTime);
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Изменить время',
                            style: AppFonts.h3Medium.copyWith(color: textColor),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(dialogContext).pop(),
                          child: const Icon(Icons.close, color: AppColors.grey),
                        ),
                      ],
                    ),
                    const Gap(12),
                    SizedBox(
                      height: 220,
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: hourController,
                              itemExtent: 42,
                              useMagnifier: true,
                              magnification: 1.08,
                              onSelectedItemChanged: (index) {
                                setDialogState(() => selectedHour = index);
                              },
                              children: List<Widget>.generate(
                                24,
                                (index) => Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: AppFonts.h2Semi.copyWith(
                                      color: wheelTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: minuteController,
                              itemExtent: 42,
                              useMagnifier: true,
                              magnification: 1.08,
                              onSelectedItemChanged: (index) {
                                setDialogState(
                                  () => selectedMinute = minuteValues[index],
                                );
                              },
                              children: List<Widget>.generate(
                                minuteValues.length,
                                (index) => Center(
                                  child: Text(
                                    minuteValues[index].toString().padLeft(
                                      2,
                                      '0',
                                    ),
                                    style: AppFonts.h2Semi.copyWith(
                                      color: wheelTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    MainButton(
                      title: isAvailable
                          ? 'Сохранить'
                          : 'Время занято или недоступно',
                      isActive: isAvailable,
                      onTap: () =>
                          Navigator.of(dialogContext).pop(selectedTime),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked == null || !mounted) return;
    onSelect(picked);
  }

  void _addServiceBlock() {
    setState(() => _services.add(_ServiceBlockState()));
  }

  void _removeServiceBlock(int index) {
    if (_services.length <= 1) return;
    setState(() {
      _services.removeAt(index);
    });
  }

  WorkerServiceItem? _selectedWorkerService(
    List<WorkerServiceItem> workerServices,
    int? selectedServiceId,
  ) {
    if (selectedServiceId == null) return null;
    for (final service in workerServices) {
      if (service.id == selectedServiceId) return service;
    }
    return null;
  }

  double _calculateSelectedServicesTotal(
    List<WorkerServiceItem> workerServices,
  ) {
    double total = 0;
    for (final block in _services) {
      final selected = _selectedWorkerService(
        workerServices,
        block.selectedServiceId,
      );
      if (selected != null) {
        total += selected.price;
      }
    }
    return total;
  }

  double _applyDiscount({
    required double total,
    required double discountPercent,
  }) {
    final normalizedDiscount = discountPercent.clamp(0, 100).toDouble();
    final discounted = total * (1 - normalizedDiscount / 100);
    if (discounted < 0) return 0;
    return discounted;
  }

  void _syncInitialServicesWithWorkerServices(
    List<WorkerServiceItem> workerServices,
  ) {
    var hasChanges = false;
    for (final block in _services) {
      if (block.selectedServiceId != null) continue;
      final initialServiceName = block.initialServiceName;
      if (initialServiceName == null || initialServiceName.isEmpty) continue;

      WorkerServiceItem? matched;
      for (final service in workerServices) {
        if (service.service.name.toLowerCase() ==
            initialServiceName.toLowerCase()) {
          matched = service;
          break;
        }
      }
      if (matched == null) {
        for (final service in workerServices) {
          if (service.service.name.toLowerCase().contains(
            initialServiceName.toLowerCase(),
          )) {
            matched = service;
            break;
          }
        }
      }
      if (matched != null) {
        block.selectedServiceId = matched.id;
        if (block.durationMinutes <= 0) {
          block.durationMinutes = matched.duration;
        }
        block.addDurationMinutes = matched.addDuration;
        block.initialServiceName = null;
        hasChanges = true;
      }
    }

    if (!hasChanges || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final workerLabels =
        ref.watch(workerEntityLabelsProvider).value ??
        WorkerEntityLabels.defaults;
    final permissions = ref.watch(workerPermissionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final canSeeContactData = permissions?.seeContactData ?? true;
    final canChangeStatus = permissions?.changeStatus ?? true;
    final canChangeWorker = permissions?.changeWorker ?? true;
    final canTransferSchedule = permissions?.transferSchedule ?? true;
    final roleId = ref.watch(roleProvider);
    final isWorkerRole = roleId == UserRole.worker.value;
    final currentWorkerIdAsync = ref.watch(currentWorkerIdProvider);
    final currentWorkerId = currentWorkerIdAsync.value;
    final isEditingEntry = widget.initialAppointment != null;
    final workerCanPickTransferTarget =
        isWorkerRole && isEditingEntry && canTransferSchedule;
    final useWorkerReadOnlySpecialistTile =
        isWorkerRole && !workerCanPickTransferTarget;
    if (isWorkerRole &&
        !workerCanPickTransferTarget &&
        currentWorkerId != null &&
        currentWorkerId > 0 &&
        _selectedSpecialistId != currentWorkerId) {
      final wid = currentWorkerId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _ensureSpecialistLockedToCurrentWorker(wid);
      });
    }

    _syncPhoneFieldForSelectedClientPrivacy(canSeeContactData);

    final workersAsync = ref.watch(scheduleWorkersProvider);
    final branchId = ref.watch(currentBranchIdProvider);
    /// Услуги текущего выбранного воркера (по состоянию формы), чтобы сопоставить
    /// выбранные позиции с id услуги в каталоге — без цикла «список специалистов».
    final workerServicesForCatalogAsync = _selectedSpecialistId == null
        ? const AsyncValue.data(<WorkerServiceItem>[])
        : ref.watch(workerServicesForWorkerProvider(_selectedSpecialistId!));
    final workerServicesForCatalog =
        workerServicesForCatalogAsync.value ?? const <WorkerServiceItem>[];
    final requiredCatalogServiceIds = <int>{};
    for (final block in _services) {
      final sid = block.selectedServiceId;
      if (sid == null) continue;
      final item = _selectedWorkerService(workerServicesForCatalog, sid);
      final cid = item?.service.id;
      if (cid != null && cid != 0) requiredCatalogServiceIds.add(cid);
    }
    /// Новая запись у воркера — только на себя. Редактирование с transfer_schedule —
    /// подбор специалистов по тем же услугам каталога, что и у администратора.
    final specialistFilterKeyForWatch =
        (isWorkerRole && !workerCanPickTransferTarget)
        ? '$branchId|all'
        : (requiredCatalogServiceIds.isEmpty
              ? '$branchId|all'
              : '$branchId|${([...requiredCatalogServiceIds]..sort()).join(',')}');
    final eligibleSpecialistIdsAsync = ref.watch(
      workersOfferingCatalogServicesProvider(specialistFilterKeyForWatch),
    );
    final specialistsBase = workersAsync.maybeWhen(
      data: (response) => response.results
          .map(
            (worker) => _SpecialistOption(
              id: worker.id,
              fullName: '${worker.firstName ?? ''} ${worker.lastName ?? ''}'
                  .trim(),
              avatarUrl: worker.pictureThumbnail ?? worker.picture,
            ),
          )
          .toList(),
      orElse: () => const <_SpecialistOption>[],
    );
    final List<_SpecialistOption> specialists;
    if (isWorkerRole) {
      if (currentWorkerId != null && currentWorkerId > 0) {
        if (workerCanPickTransferTarget) {
          specialists = eligibleSpecialistIdsAsync.when(
            data: (eligible) => specialistsBase
                .where((s) => eligible.contains(s.id))
                .toList(),
            loading: () {
              final keepId = _selectedSpecialistId ?? currentWorkerId;
              return specialistsBase.where((s) => s.id == keepId).toList();
            },
            error: (_, __) {
              final keepId = _selectedSpecialistId ?? currentWorkerId;
              return specialistsBase.where((s) => s.id == keepId).toList();
            },
          );
        } else {
          specialists = specialistsBase
              .where((s) => s.id == currentWorkerId)
              .toList();
        }
      } else {
        specialists = const [];
      }
    } else if (requiredCatalogServiceIds.isEmpty) {
      specialists = specialistsBase;
    } else {
      specialists = eligibleSpecialistIdsAsync.when(
        data: (eligible) => specialistsBase
            .where((s) => eligible.contains(s.id))
            .toList(),
        loading: () {
          final keepId = _selectedSpecialistId;
          if (keepId != null && keepId > 0) {
            final match =
                specialistsBase.where((s) => s.id == keepId).toList();
            if (match.isNotEmpty) return match;
          }
          return const <_SpecialistOption>[];
        },
        error: (_, __) => specialistsBase,
      );
    }
    final selectedSpecialistId =
        specialists.any((item) => item.id == _selectedSpecialistId)
        ? _selectedSpecialistId
        : null;
    final workerServicesAsync = selectedSpecialistId == null
        ? const AsyncValue.data(<WorkerServiceItem>[])
        : ref.watch(workerServicesForWorkerProvider(selectedSpecialistId));
    final selectedDateOnly = _dateOnly(_selectedDate);
    final selectedShiftAsync = ref.watch(
      availableWorkersForDateProvider(selectedDateOnly),
    );
    final selectedShift = selectedSpecialistId == null
        ? null
        : _shiftForSpecialist(
            selectedShiftAsync.value ?? const [],
            selectedSpecialistId,
          );
    final dayStart = selectedDateOnly;
    final dayEnd = dayStart
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    final specialistAppointmentsAsync = selectedSpecialistId == null
        ? const AsyncValue.data(<AppointmentApi>[])
        : ref.watch(
            scheduleAppointmentsProvider(
              AppointmentsQuery(
                workerId: selectedSpecialistId,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              ),
            ),
          );
    final specialistAppointments =
        specialistAppointmentsAsync.value ?? const <AppointmentApi>[];
    final workerDailyScheduleAsync = selectedSpecialistId == null
        ? null
        : ref.watch(
            workerSchedulesRangeProvider(
              WorkerSchedulesRangeQuery(
                workerId: selectedSpecialistId,
                rangeStart: selectedDateOnly,
                rangeEnd: selectedDateOnly,
              ),
            ),
          );
    final workerDailySchedule =
        workerDailyScheduleAsync?.value?.scheduleOn(selectedDateOnly);
    final workerServices =
        workerServicesAsync.value ?? const <WorkerServiceItem>[];
    if (selectedSpecialistId != null && workerServices.isNotEmpty) {
      _syncInitialServicesWithWorkerServices(workerServices);
    }
    final subtotal = _calculateSelectedServicesTotal(workerServices);
    final selectedClientDiscount = _selectedClient?.discount ?? 0;
    final selectedServicesTotal = _applyDiscount(
      total: subtotal,
      discountPercent: selectedClientDiscount,
    );
    final totalNotifier = ref.read(createEntryTotalPriceProvider.notifier);
    if (totalNotifier.state != selectedServicesTotal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(createEntryTotalPriceProvider.notifier).state =
            selectedServicesTotal;
      });
    }
    final discountNotifier = ref.read(createEntryDiscountProvider.notifier);
    if (discountNotifier.state != selectedClientDiscount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(createEntryDiscountProvider.notifier).state =
            selectedClientDiscount;
      });
    }
    final draft = _buildCreateDraft(
      workerServices: workerServices,
      selectedSpecialistId: selectedSpecialistId,
      branchId: branchId,
      totalSum: selectedServicesTotal,
      selectedClientDiscount: selectedClientDiscount,
      canSeeContactData: canSeeContactData,
    );
    final hasCompleteService = _services.any(
      (service) =>
          service.selectedServiceId != null &&
          (service.selectedTime?.isNotEmpty ?? false),
    );
    final canSave =
        selectedSpecialistId != null && branchId != 0 && hasCompleteService;
    final canSaveNotifier = ref.read(createEntryCanSaveProvider.notifier);
    if (canSaveNotifier.state != canSave) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(createEntryCanSaveProvider.notifier).state = canSave;
      });
    }
    final draftNotifier = ref.read(createEntryDraftProvider.notifier);
    if (draftNotifier.state != draft) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(createEntryDraftProvider.notifier).state = draft;
      });
    }
    final clientsAsync = ref.watch(
      clientsByPhoneSearchProvider(_phoneSearchQuery),
    );
    final clientsByPhone = clientsAsync.value ?? const <ClientItem>[];
    final shouldShowClientCommentField =
        _selectedClient == null ||
        ((_selectedClient?.commentText ?? '').trim().isNotEmpty);

    final cardSurface = _entryCardSurface(context);
    final mutedFill = _entryMutedFill(context);
    final divider = _entryDivider(context);
    final accent = _entryAccent(context);
    final primaryText = _entryPrimaryText(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          DefaultContainerWidget(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            hasShadow: false,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            color: cardSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(8),

                // Комментарий к визиту
                GestureDetector(
                  onTap: () {
                    setState(
                      () => _isCommentVisitExpanded = !_isCommentVisitExpanded,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Комментарий к визиту', style: AppFonts.c1Medium),
                      Image.asset(
                        _isCommentVisitExpanded
                            ? AppImages.arrowOutlinedDown
                            : AppImages.arrowOutlinedTop,
                      ),
                    ],
                  ),
                ),
                if (_isCommentVisitExpanded) ...[
                  Gap(16),
                  MainTextField(
                    controller: _commentVisitController,
                    hintText: 'Введите комментарий',
                    maxLines: 3,
                    isMultiline: true,
                    borderRadius: BorderRadius.circular(16),
                    canEdit: !widget.viewOnly,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                Gap(16),
                IgnorePointer(
                  ignoring: !canChangeStatus || widget.viewOnly,
                  child: Opacity(
                    opacity: canChangeStatus && !widget.viewOnly ? 1 : 0.6,
                    child: ClientStatusSelectorWidget(
                      initialIndex: _selectedStatusIndex,
                      onSelected: canChangeStatus
                          ? (index, _) {
                              unawaited(_onClientStatusSelected(index));
                            }
                          : null,
                    ),
                  ),
                ),
                Gap(12),
                MainTextField(
                  controller: _phoneController,
                  label: 'Телефон',
                  hintText: 'Телефон',
                  canEdit: !widget.viewOnly,
                  keyboardType: TextInputType.number,
                  inputFormatters: canSeeContactData || _selectedClient == null
                      ? <TextInputFormatter>[_phoneMaskFormatter]
                      : <TextInputFormatter>[_passthroughPhoneMaskFormatter],
                  onCleared: () {
                    unawaited(_clearRememberedClientIfChanged(''));
                    setState(() {
                      _phoneSearchQuery = '';
                      _showClientSuggestions = false;
                      _selectedClient = null;
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _commentClientController.clear();
                    });
                  },
                  onChanged: (value) {
                    unawaited(_clearRememberedClientIfChanged(value));
                    setState(() {
                      _phoneSearchQuery = value;
                      _showClientSuggestions = value.trim().isNotEmpty;
                      _selectedClient = null;
                      if (value.trim().isEmpty) {
                        _firstNameController.clear();
                        _lastNameController.clear();
                        _commentClientController.clear();
                      }
                    });
                  },
                ),
                if (!widget.viewOnly && _showClientSuggestions) ...[
                    const Gap(8),
                    DefaultContainerWidget(
                      color: mutedFill,
                      borderRadius: BorderRadius.circular(16),
                      hasShadow: false,
                      hasBorder: true,
                      borderColor: divider,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: clientsAsync.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : clientsByPhone.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Клиент не найден',
                                style: AppFonts.c1Regular.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                for (
                                  var i = 0;
                                  i < clientsByPhone.length;
                                  i++
                                ) ...[
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      '${clientsByPhone[i].firstName} ${clientsByPhone[i].lastName}'
                                          .trim(),
                                      style: AppFonts.c1Regular,
                                    ),
                                    subtitle: Text(
                                      canSeeContactData
                                          ? clientsByPhone[i].phone
                                          : _maskPhoneLastFourDigitsForList(
                                              clientsByPhone[i].phone,
                                            ),
                                      style: AppFonts.c2Tabbar.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedClient = clientsByPhone[i];
                                        _phoneController.text =
                                            canSeeContactData
                                            ? clientsByPhone[i].phone
                                            : _maskPhoneLastFourDigitsForList(
                                                clientsByPhone[i].phone,
                                              );
                                        _firstNameController.text =
                                            clientsByPhone[i].firstName;
                                        _lastNameController.text =
                                            clientsByPhone[i].lastName;
                                        _commentClientController.text =
                                            clientsByPhone[i].commentText ?? '';
                                        _phoneSearchQuery =
                                            clientsByPhone[i].phone;
                                        _showClientSuggestions = false;
                                        if ((clientsByPhone[i].commentText ?? '')
                                            .trim()
                                            .isNotEmpty) {
                                          _isCommentClientExpanded = true;
                                        }
                                      });
                                    },
                                  ),
                                  if (i < clientsByPhone.length - 1)
                                    Divider(height: 1, color: divider),
                                ],
                              ],
                            ),
                    ),
                ],
                Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: MainTextField(
                        controller: _firstNameController,
                        label: 'Имя',
                        hintText: 'Иван',
                        canEdit: !widget.viewOnly,
                        onChanged: (_) {
                          if (_selectedClient != null) {
                            setState(() {
                              _selectedClient = null;
                            });
                          }
                        },
                      ),
                    ),
                    Gap(12),
                    Expanded(
                      child: MainTextField(
                        controller: _lastNameController,
                        label: 'Фамилия',
                        hintText: 'Иванов',
                        canEdit: !widget.viewOnly,
                        onChanged: (_) {
                          if (_selectedClient != null) {
                            setState(() {
                              _selectedClient = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (shouldShowClientCommentField) ...[
                  Gap(24),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => _isCommentClientExpanded =
                            !_isCommentClientExpanded,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Комментарий к клиенту', style: AppFonts.c1Medium),
                        Image.asset(
                          _isCommentClientExpanded
                              ? AppImages.arrowOutlinedDown
                              : AppImages.arrowOutlinedTop,
                        ),
                      ],
                    ),
                  ),
                  if (_isCommentClientExpanded) ...[
                    Gap(16),
                    MainTextField(
                      controller: _commentClientController,
                      hintText: 'Введите комментарий',
                      maxLines: 3,
                      isMultiline: true,
                      borderRadius: BorderRadius.circular(16),
                      canEdit: !widget.viewOnly,
                    ),
                  ],
                  Gap(16),
                ],
              ],
            ),
          ),

          Gap(20),

          if (_selectedClient != null) ...[
            DefaultContainerWidget(
              borderRadius: BorderRadius.circular(24),
              hasShadow: false,
              color: cardSurface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'О клиенте',
                    style: AppFonts.b1Medium.copyWith(color: primaryText),
                  ),
                  Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(16),
                          hasShadow: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Баланс', style: AppFonts.c1Medium),
                              Gap(8),
                              Text(
                                _formatMoney(_selectedClient!.balance),
                                style: AppFonts.b1Medium.copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(12),
                      Expanded(
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(16),
                          hasShadow: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('КНК', style: AppFonts.c1Medium),
                              Gap(8),
                              Text(
                                _selectedClient!.reliabilityFactor.toString(),
                                style: AppFonts.b1Medium.copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(12),
                      Expanded(
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(16),
                          hasShadow: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Визитов', style: AppFonts.c1Medium),
                              Gap(8),
                              Text(
                                _selectedClient!.numberOfVisits.toString(),
                                style: AppFonts.b1Medium.copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(16),
                          hasShadow: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Скидка', style: AppFonts.c1Medium),
                              Gap(8),
                              Text(
                                '${_selectedClient!.discount.round()}%',
                                style: AppFonts.b1Medium.copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(12),
                      Expanded(
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(16),
                          hasShadow: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Средний чек', style: AppFonts.c1Medium),
                              Gap(8),
                              Text(
                                _formatMoney(
                                  _selectedClient!.numberOfVisits > 0
                                      ? _selectedClient!.transactionsSum /
                                            _selectedClient!.numberOfVisits
                                      : 0,
                                ),
                                style: AppFonts.b1Medium.copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(20),
          ],

          DefaultContainerWidget(
            borderRadius: BorderRadius.circular(24),
            hasShadow: false,
            color: cardSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.viewOnly)
                  ..._viewOnlyMasterServicesChildren(
                    mutedFill: mutedFill,
                    divider: divider,
                    primaryText: primaryText,
                    accent: accent,
                    workerLabels: workerLabels,
                    isWorkerRole: isWorkerRole,
                  )
                else ...[
                Text(workerLabels.sectionAndServices, style: AppFonts.b1Medium),
                Gap(16),
                Text(
                  workerLabels.workerFieldLabel(isWorkerRole: isWorkerRole),
                  style: AppFonts.c1Medium,
                ),
                Gap(8),
                if (useWorkerReadOnlySpecialistTile)
                  DefaultContainerWidget(
                    color: mutedFill,
                    borderRadius: BorderRadius.circular(300),
                    hasShadow: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: currentWorkerIdAsync.isLoading
                        ? Text(
                            'Загрузка профиля…',
                            style: AppFonts.c1Regular.copyWith(
                              color: AppColors.grey,
                            ),
                          )
                        : workersAsync.isLoading
                        ? Text(
                            workerLabels.loadingWorkers,
                            style: AppFonts.c1Regular.copyWith(
                              color: AppColors.grey,
                            ),
                          )
                        : specialists.isNotEmpty
                        ? _SpecialistDropdownTile(
                            fullName: specialists.first.fullName,
                            avatarUrl: specialists.first.avatarUrl,
                          )
                        : Text(
                            'Сотрудник не найден в филиале',
                            style: AppFonts.c1Regular.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                  )
                else
                  DropdownButtonFormField2<int>(
                  valueListenable: ValueNotifier<int?>(selectedSpecialistId),
                  isExpanded: true,
                  alignment: AlignmentDirectional.centerStart,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) _specialistDropdownSearchController.clear();
                  },
                  style: AppFonts.c1Regular.copyWith(color: primaryText),
                  hint: Text(
                    workersAsync.isLoading
                        ? workerLabels.loadingWorkers
                        : (requiredCatalogServiceIds.isNotEmpty &&
                              eligibleSpecialistIdsAsync.isLoading)
                        ? workerLabels.matchingWorkersByService
                        : workerLabels.hintSelect,
                    style: AppFonts.c1Regular.copyWith(color: primaryText),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mutedFill,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Image.asset(AppImages.arrowOutlinedDown),
                  ),
                  buttonStyleData: const FormFieldButtonStyleData(
                    padding: EdgeInsets.zero,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: const Offset(0, 8),
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: mutedFill,
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    useDecorationHorizontalPadding: true,
                  ),
                  dropdownSearchData: DropdownSearchData<int>(
                    searchController: _specialistDropdownSearchController,
                    searchBarWidgetHeight: 52,
                    noResultsWidget: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        workerLabels.notFound,
                        style: AppFonts.c1Regular.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    searchBarWidget: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: _specialistDropdownSearchController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: workerLabels.searchByWorker,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: divider),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      final specialist = specialists.firstWhere(
                        (s) => s.id == item.value,
                        orElse: () =>
                            const _SpecialistOption(id: 0, fullName: ''),
                      );
                      return specialist.fullName.toLowerCase().contains(
                        searchValue.toLowerCase(),
                      );
                    },
                  ),
                  items: specialists
                      .map(
                        (specialist) => DropdownItem<int>(
                          value: specialist.id,
                          child: _SpecialistDropdownTile(
                            fullName: specialist.fullName,
                            avatarUrl: specialist.avatarUrl,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: ((!canChangeWorker && !workerCanPickTransferTarget) ||
                          specialists.isEmpty)
                      ? null
                      : _onSpecialistChanged,
                ),
                Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дата', style: AppFonts.c1Medium),
                    GestureDetector(
                      onTap: (selectedSpecialistId == null ||
                              !canTransferSchedule ||
                              _datePickerInFlight)
                          ? null
                          : () => unawaited(_pickDate()),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 120,
                        child: DefaultContainerWidget(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(300),
                          hasShadow: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _formatDate(_selectedDate),
                                  style: AppFonts.c1Regular.copyWith(
                                    color: selectedSpecialistId == null
                                        ? AppColors.grey
                                        : primaryText,
                                  ),
                                ),
                              ),

                              Image.asset(
                                AppImages.calendarTab,
                                width: 18,
                                height: 18,
                                color: selectedSpecialistId == null
                                    ? AppColors.grey
                                    : accent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                for (var index = 0; index < _services.length; index++) ...[
                  Divider(height: 32, color: divider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Услуга ${index + 1}', style: AppFonts.c1Medium),
                      GestureDetector(
                        onTap: () => _removeServiceBlock(index),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField2<int>(
                          valueListenable: ValueNotifier<int?>(
                            _services[index].selectedServiceId,
                          ),
                          isExpanded: true,
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _services[index].serviceSearchController.clear();
                            }
                          },
                          style: AppFonts.c1Regular.copyWith(
                            color: primaryText,
                          ),
                          hint: Text(
                            selectedSpecialistId == null
                                ? workerLabels.selectWorkerFirst
                                : (workerServicesAsync.isLoading
                                      ? 'Загрузка услуг...'
                                      : 'Название услуги'),
                            style: AppFonts.c1Regular.copyWith(
                              color: primaryText,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: mutedFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(300),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(300),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(300),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Image.asset(AppImages.arrowOutlinedDown),
                          ),
                          buttonStyleData: const FormFieldButtonStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(0, 8),
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: mutedFill,
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            useDecorationHorizontalPadding: true,
                          ),
                          dropdownSearchData: DropdownSearchData<int>(
                            searchController:
                                _services[index].serviceSearchController,
                            searchBarWidgetHeight: 52,
                            searchBarWidget: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: TextField(
                                controller:
                                    _services[index].serviceSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Поиск услуги',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: divider),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: divider),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              final service = workerServices.firstWhere(
                                (s) => s.id == item.value,
                                orElse: () => WorkerServiceItem(
                                  id: 0,
                                  branch: 0,
                                  worker: 0,
                                  price: 0,
                                  duration: 0,
                                  addDuration: 0,
                                  service: WorkerServiceInfo(
                                    id: 0,
                                    name: '',
                                    price: 0,
                                    duration: 0,
                                  ),
                                ),
                              );
                              return service.service.name
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase());
                            },
                          ),
                          items: workerServices
                              .map(
                                (service) => DropdownItem<int>(
                                  value: service.id,
                                  child: Text(
                                    service.service.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.c1Regular.copyWith(
                                      color: primaryText,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: selectedSpecialistId == null
                              ? null
                              : (value) {
                                  final selected = _selectedWorkerService(
                                    workerServices,
                                    value,
                                  );
                                  setState(() {
                                    final previousServiceId =
                                        _services[index].selectedServiceId;
                                    _services[index].selectedServiceId = value;
                                    if (selected != null) {
                                      _services[index].durationMinutes =
                                          selected.duration;
                                      _services[index].addDurationMinutes =
                                          selected.addDuration;
                                    }
                                    // Время не сбрасываем заранее: после смены услуги
                                    // оставляем слот, если он валиден для новой длительности.
                                    // Если невалиден — ниже сработает авто-очистка и сообщение.
                                    if (previousServiceId != value &&
                                        previousServiceId != null) {
                                      _services[index].appointmentServiceId =
                                          null;
                                    }
                                  });
                                },
                        ),
                      ),
                      const Gap(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(() {
                          final selected = _selectedWorkerService(
                            workerServices,
                            _services[index].selectedServiceId,
                          );
                          if (selected == null) return '0 ₽';
                          final p = selected.price;
                          final formatted = p % 1 == 0
                              ? p.toInt().toString()
                              : p.toStringAsFixed(2);
                          return '$formatted ₽';
                        }(), style: AppFonts.c1Medium.copyWith(color: accent)),
                      ),
                    ],
                  ),
                  const Gap(16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _services[index].isTimeExpanded =
                            !_services[index].isTimeExpanded;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Время', style: AppFonts.c1Medium),
                        Image.asset(
                          _services[index].isTimeExpanded
                              ? AppImages.arrowOutlinedDown
                              : AppImages.arrowOutlinedTop,
                        ),
                      ],
                    ),
                  ),
                  if (_services[index].isTimeExpanded) ...[
                    const Gap(12),
                    if (selectedSpecialistId == null)
                      Text(
                        workerLabels.selectWorkerFirst,
                        style: AppFonts.c1Regular.copyWith(
                          color: AppColors.grey,
                        ),
                      )
                    else if (selectedShiftAsync.isLoading ||
                        specialistAppointmentsAsync.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      Builder(
                        builder: (context) {
                          final hasSelectedService =
                              _services[index].selectedServiceId != null;
                          final availableSlots = _availableSlotsForService(
                            date: selectedDateOnly,
                            durationMinutes:
                                _services[index].totalDurationMinutes,
                            shift: selectedShift,
                            daily: workerDailySchedule,
                            appointments: specialistAppointments,
                            currentServiceIndex: index,
                          );

                          final selectedTime = _services[index].selectedTime;
                          final initialAppointment = widget.initialAppointment;
                          final preserveEditTime =
                              initialAppointment != null &&
                              selectedTime != null &&
                              _isInitialServiceTime(
                                initialAppointment,
                                index,
                                selectedTime,
                              );
                          if (hasSelectedService &&
                              selectedTime != null &&
                              !availableSlots.contains(selectedTime) &&
                              !preserveEditTime) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              if (index >= _services.length) return;
                              if (_services[index].selectedTime != null &&
                                  !availableSlots.contains(
                                    _services[index].selectedTime,
                                  )) {
                                setState(() {
                                  _services[index].selectedTime = null;
                                });
                                if (!mounted) return;
                                final messenger = ScaffoldMessenger.maybeOf(
                                  this.context,
                                );
                                showAppServiceMessage(
                                  this.context,
                                  message:
                                      'Временной слот не подходит. Выберите другой',
                                  variant: AppServiceMessageVariant.info,
                                  messenger: messenger,
                                );
                              }
                            });
                          }

                          if (availableSlots.isEmpty) {
                            return Text(
                              'Нет свободного времени на выбранную длительность',
                              style: AppFonts.c1Regular.copyWith(
                                color: AppColors.grey,
                              ),
                            );
                          }

                          final morning = _slotsByHourRange(
                            availableSlots,
                            fromHourInclusive: 0,
                            toHourExclusive: 12,
                          );
                          final day = _slotsByHourRange(
                            availableSlots,
                            fromHourInclusive: 12,
                            toHourExclusive: 17,
                          );
                          final evening = _slotsByHourRange(
                            availableSlots,
                            fromHourInclusive: 17,
                            toHourExclusive: 24,
                          );

                          Widget section(String title, List<String> slots) {
                            if (slots.isEmpty) return const SizedBox.shrink();
                            return Column(
                              children: [
                                Center(
                                  child: Text(title, style: AppFonts.c1Regular),
                                ),
                                const Gap(8),
                                _buildTimeRows(
                                  context: context,
                                  slots: slots,
                                  selectedTime: _services[index].selectedTime,
                                  onSelect: (time) {
                                    if (!canTransferSchedule) return;
                                    setState(
                                      () =>
                                          _services[index].selectedTime = time,
                                    );
                                  },
                                  onLongPressSlot: (initialTime) {
                                    _showManualTimePickerDialog(
                                      availableSlots: availableSlots,
                                      initialTime: initialTime,
                                      onSelect: (time) {
                                        if (!canTransferSchedule) return;
                                        setState(
                                          () => _services[index].selectedTime =
                                              time,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!hasSelectedService) ...[
                                Text(
                                  'Сначала выберите услугу',
                                  style: AppFonts.c1Regular.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                const Gap(8),
                              ],
                              section('Утро', morning),
                              if (morning.isNotEmpty &&
                                  (day.isNotEmpty || evening.isNotEmpty))
                                const Gap(12),
                              section('День', day),
                              if (day.isNotEmpty && evening.isNotEmpty)
                                const Gap(12),
                              section('Вечер', evening),
                            ],
                          );
                        },
                      ),
                    ],
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${_services[index].totalDurationMinutes} минут',
                          style: AppFonts.c1Regular,
                        ),
                        const Gap(12),
                        Container(
                          decoration: BoxDecoration(
                            color: mutedFill,
                            borderRadius: BorderRadius.circular(300),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final current =
                                        _services[index].durationMinutes;
                                    _services[index].durationMinutes =
                                        (current - 10) < 0 ? 0 : current - 10;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  child: Image.asset(AppImages.minus),
                                ),
                              ),
                              Container(width: 1, height: 20, color: divider),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _services[index].durationMinutes += 10;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  child: Image.asset(AppImages.plus),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _addServiceBlock,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: mutedFill,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Добавить услугу',
                              style: AppFonts.c1Semi.copyWith(color: accent),
                            ),
                            const Gap(8),
                            Text(
                              '+',
                              style: TextStyle(
                                fontSize: 20,
                                color: accent,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ],
              ],
            ),
          ),
          const Gap(20),
          DefaultContainerWidget(
            borderRadius: BorderRadius.circular(24),
            hasShadow: false,
            color: cardSurface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Источник', style: AppFonts.c1Medium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: mutedFill,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.initialAppointment?.source == 3)
                        Icon(Icons.link, size: 16, color: primaryText)
                      else
                        Image.asset(AppImages.solidFull),
                      const Gap(6),
                      Text(
                        widget.initialAppointment?.sourceDisplayLabel ??
                            'Админ',
                        style: AppFonts.c1Regular.copyWith(color: primaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeRange {
  const _DateTimeRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _BottomActionsBar extends ConsumerWidget {
  const _BottomActionsBar({
    required this.isEditMode,
    required this.initialAppointmentId,
    this.initialAppointmentDatetime,
  });

  final bool isEditMode;
  final int? initialAppointmentId;
  final String? initialAppointmentDatetime;

  String _formatMoney(double value) => '${value.round()}₽';
  String _formatDiscount(double value) => '${value.round()}%';
  String _extractErrorMessage(Object error) {
    if (error is CustomException) {
      final caused = error.causedError;
      if (caused is DioException) {
        final data = caused.response?.data;
        if (data is Map<String, dynamic>) return data.toString();
        if (data is List<dynamic>) return data.toString();
        if (data is String && data.trim().isNotEmpty) return data;
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!;
      }
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(workerPermissionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final canCreateSchedule = permissions?.createSchedule ?? true;
    final canEditSchedule =
        (permissions?.transferSchedule ?? true) ||
        (permissions?.changeWorker ?? true) ||
        (permissions?.changeStatus ?? true) ||
        (permissions?.change ?? true);
    final canSubmitByPermissions = isEditMode ? canEditSchedule : canCreateSchedule;

    final totalPrice = ref.watch(createEntryTotalPriceProvider);
    final discount = ref.watch(createEntryDiscountProvider);
    final canSave = ref.watch(createEntryCanSaveProvider);
    final isSaving = ref.watch(createEntrySavingProvider);
    final draft = ref.watch(createEntryDraftProvider);
    final cardSurface = _entryCardSurface(context);
    final mutedFill = _entryMutedFill(context);
    final accent = _entryAccent(context);

    Future<void> createAppointment({required bool closeAfterSave}) async {
      if (!canSubmitByPermissions || !canSave || draft == null || isSaving) {
        return;
      }
      ref.read(createEntrySavingProvider.notifier).state = true;
      try {
        var resolvedClientId = draft.clientId;
        final shouldCreateClient =
            draft.shouldCreateClient ||
            (resolvedClientId == null &&
                draft.clientPhone.isNotEmpty &&
                draft.clientFirstName.isNotEmpty &&
                draft.clientLastName.isNotEmpty);
        if (shouldCreateClient) {
          final createdClient = await ref
              .read(clientsServiceProvider)
              .createClient(
                phone: draft.clientPhone,
                firstName: draft.clientFirstName,
                lastName: draft.clientLastName,
                commentText: draft.clientCommentText,
                status: draft.status,
              );
          resolvedClientId = createdClient.id;
          ref.invalidate(clientsByPhoneSearchProvider);
          ref.invalidate(clientsByPhoneSearchProvider(draft.clientPhone));
        }
        int? createdId;
        if (isEditMode) {
          final appointmentId = initialAppointmentId ?? draft.appointmentId;
          if (appointmentId == null) {
            throw Exception('Appointment id is missing');
          }
          await ref
              .read(appointmentsServiceProvider)
              .updateAppointment(
                appointmentId: appointmentId,
                payload: draft.toUpdateRequestBody(
                  overrideClientId: resolvedClientId,
                ),
              );
          createdId = appointmentId;
        } else {
          final created = await ref
              .read(appointmentsServiceProvider)
              .createAppointment(
                payload: draft.toRequestBody(
                  overrideClientId: resolvedClientId,
                ),
              );
          createdId = created.isNotEmpty
              ? (created.first['id'] as num?)?.toInt()
              : null;
        }
        ref.invalidate(scheduleAppointmentsProvider);
        DateTime? oldDayLocal;
        if (isEditMode && initialAppointmentDatetime != null) {
          final raw = initialAppointmentDatetime!.trim();
          if (raw.isNotEmpty) {
            final parsed = DateTime.tryParse(raw);
            if (parsed != null) {
              final loc = parsed.toLocal();
              oldDayLocal = DateTime(loc.year, loc.month, loc.day);
            }
          }
        }
        _invalidateScheduleStatsForDateMoveWidgetRef(
          ref,
          draft.startDateTime,
          oldDayLocal,
        );
        if (context.mounted) {
          final retryContainer = ProviderScope.containerOf(
            context,
            listen: false,
          );
          final retryNewDay = DateTime(
            draft.startDateTime.year,
            draft.startDateTime.month,
            draft.startDateTime.day,
          );
          unawaited(Future<void>.delayed(const Duration(milliseconds: 550), () {
            _invalidateScheduleStatsForDayContainer(retryContainer, retryNewDay);
            if (oldDayLocal != null) {
              final oldD = DateTime(
                oldDayLocal.year,
                oldDayLocal.month,
                oldDayLocal.day,
              );
              if (oldD != retryNewDay) {
                _invalidateScheduleStatsForDayContainer(
                  retryContainer,
                  oldDayLocal,
                );
              }
            }
          }));
        }
        if (!context.mounted) return;
        showAppServiceMessage(
          context,
          message: isEditMode
              ? 'Запись успешно обновлена'
              : 'Запись успешно создана',
        );
        if (closeAfterSave) {
          context.pop(true);
        } else if (createdId != null) {
          final dayStart = DateTime(
            draft.startDateTime.year,
            draft.startDateTime.month,
            draft.startDateTime.day,
          );
          final dayEnd = dayStart
              .add(const Duration(days: 1))
              .subtract(const Duration(milliseconds: 1));
          final dayAppointments = await ref
              .read(appointmentsServiceProvider)
              .getAppointments(
                branchId: draft.branchId,
                workerId: draft.workerId,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              );
          AppointmentApi? createdAppointment;
          for (final item in dayAppointments.results) {
            if (item.id == createdId) {
              createdAppointment = item;
              break;
            }
          }
          if (createdAppointment != null && context.mounted) {
            context.pushReplacementNamed(
              AddNewEntryPage.name,
              extra: createdAppointment,
            );
          }
        }
      } catch (e) {
        if (!context.mounted) return;
        showAppServiceMessage(
          context,
          message: isEditMode
              ? 'Не удалось обновить запись: ${_extractErrorMessage(e)}'
              : 'Не удалось создать запись: ${_extractErrorMessage(e)}',
          variant: AppServiceMessageVariant.error,
        );
      } finally {
        ref.read(createEntrySavingProvider.notifier).state = false;
      }
    }

    return DefaultContainerWidget(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 38, top: 20),
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      color: cardSurface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: DefaultContainerWidget(
                  color: mutedFill,
                  borderRadius: BorderRadius.circular(16),
                  hasShadow: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Скидка:', style: AppFonts.c1Regular),
                      const Gap(6),
                      Text(
                        _formatDiscount(discount),
                        style: AppFonts.c1Semi.copyWith(color: accent),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: DefaultContainerWidget(
                  color: mutedFill,
                  borderRadius: BorderRadius.circular(16),
                  hasShadow: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Итого:', style: AppFonts.c1Regular),
                      const Gap(6),
                      Text(
                        _formatMoney(totalPrice),
                        style: AppFonts.c1Semi.copyWith(color: accent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          MainButton(
            title: 'Сохранить',
            onTap: () => createAppointment(closeAfterSave: false),
            isActive: canSave && !isSaving && canSubmitByPermissions,
            isLoading: isSaving,
          ),
          const Gap(12),
          MainButton(
            title: 'Сохранить и закрыть',
            onTap: () => createAppointment(closeAfterSave: true),
            isActive: canSave && !isSaving && canSubmitByPermissions,
            isLoading: isSaving,
          ),
        ],
      ),
    );
  }
}

class _SpecialistOption {
  const _SpecialistOption({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  final int id;
  final String fullName;
  final String? avatarUrl;
}

class _ServiceBlockState {
  _ServiceBlockState();

  final TextEditingController serviceSearchController = TextEditingController();
  int? appointmentServiceId;
  int? selectedServiceId;
  String? initialServiceName;
  bool isTimeExpanded = true;
  String? selectedTime;
  int durationMinutes = 10;
  int addDurationMinutes = 0;

  int get totalDurationMinutes => durationMinutes + addDurationMinutes;
}

class _SpecialistDropdownTile extends StatelessWidget {
  const _SpecialistDropdownTile({required this.fullName, this.avatarUrl});

  final String fullName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 24,
          child: _SpecialistAvatar(
            avatarUrl: avatarUrl,
            size: 24,
            fullName: fullName,
          ),
        ),
        const Gap(10),
        Flexible(
          child: Text(
            fullName,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.c1Regular.copyWith(
              color: _entryPrimaryText(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.avatarUrl, this.size = 32, this.fullName});

  final String? avatarUrl;
  final double size;
  final String? fullName;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey),
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (ctx, __, ___) => _placeholder(ctx),
          ),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final initials = _extractInitials(fullName);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _entryMutedFill(context),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryDark),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppFonts.c1Medium.copyWith(
          color: AppColors.themeAccent(context),
        ),
      ),
    );
  }

  String _extractInitials(String? fullName) {
    final parts = (fullName ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '—';
    final first = parts[0].substring(0, 1).toUpperCase();
    if (parts.length == 1) return first;
    final second = parts[1].substring(0, 1).toUpperCase();
    return '$first$second';
  }
}

/// Не меняет ввод: нужен, чтобы строка с маской `****` не проходила через
/// [_PhoneMaskFormatter], который оставляет только цифры.
class _PassthroughPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      newValue;
}

class _PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    var normalized = digits;
    if (normalized.startsWith('8')) {
      normalized = '7${normalized.substring(1)}';
    } else if (!normalized.startsWith('7')) {
      normalized = '7$normalized';
    }
    if (normalized.length > 11) {
      normalized = normalized.substring(0, 11);
    }

    final buffer = StringBuffer('+${normalized[0]}');
    if (normalized.length > 1) {
      buffer.write(' (');
      final part = normalized.substring(1, normalized.length.clamp(1, 4));
      buffer.write(part);
      if (normalized.length >= 4) buffer.write(')');
    }
    if (normalized.length > 4) {
      buffer.write(' ');
      buffer.write(normalized.substring(4, normalized.length.clamp(4, 7)));
    }
    if (normalized.length > 7) {
      buffer.write('-');
      buffer.write(normalized.substring(7, normalized.length.clamp(7, 9)));
    }
    if (normalized.length > 9) {
      buffer.write('-');
      buffer.write(normalized.substring(9, normalized.length.clamp(9, 11)));
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
