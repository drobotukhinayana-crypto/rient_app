import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/create/data/models/worker_services_api.dart';
import 'package:rient_app/features/create/view/components/client_status_selector_widget.dart';
import 'package:rient_app/features/create/view/providers/worker_services_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/resources/resources.dart';

class AddNewEntryPage extends StatelessWidget {
  const AddNewEntryPage({super.key});

  static const name = 'add_new_entry_page';
  static const path = '/add_new_entry_page';

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
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
                onTap: () => Navigator.of(dialogContext).pop(),
                color: Color(0xff787880).withValues(alpha: 0.16),
                textColor: AppColors.red,
              ),
              const Gap(8),
              MainButton(
                title: 'Закрыть',
                onTap: () => Navigator.of(dialogContext).pop(),
                color: Color(0xff787880).withValues(alpha: 0.16),
                textColor: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Image.asset(AppImages.back),
            ),
            Text('Новая запись', style: AppFonts.h4Medium),
            PopupMenuButton<String>(
              color: Colors.white,
              elevation: 4,
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'remember',
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Запомнить клиента', style: AppFonts.b2Medium),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Удалить',
                    style: AppFonts.b2Medium.copyWith(color: AppColors.red),
                  ),
                ),
              ],
              child: Image.asset(AppImages.more),
            ),
          ],
        ),
      ),
      body: const _BodyWidget(),
      bottomNavigationBar: const _BottomActionsBar(),
    );
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget();

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  bool _isCommentVisitExpanded = true;
  bool _isCommentClientExpanded = true;
  final _commentVisitController = TextEditingController();
  final _commentClientController = TextEditingController();
  final List<_ServiceBlockState> _services = [_ServiceBlockState()];
  int? _selectedSpecialistId;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _commentVisitController.dispose();
    _commentClientController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ru'),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
  }

  Widget _buildTimeChip(
    String time, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 39,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainAccent : AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(300),
        ),
        child: Text(
          time,
          style: AppFonts.c1Regular.copyWith(
            color: isSelected ? Colors.white : AppColors.primaryDark,
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final workersAsync = ref.watch(scheduleWorkersProvider);
    final specialists = workersAsync.maybeWhen(
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
    final selectedSpecialistId =
        specialists.any((item) => item.id == _selectedSpecialistId)
        ? _selectedSpecialistId
        : null;
    final workerServicesAsync = selectedSpecialistId == null
        ? const AsyncValue.data(<WorkerServiceItem>[])
        : ref.watch(workerServicesForWorkerProvider(selectedSpecialistId));
    final workerServices =
        workerServicesAsync.value ?? const <WorkerServiceItem>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // заголовок
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
            color: Colors.white,
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
                  ),
                ],
                Gap(16),
                // статус клиента
                const ClientStatusSelectorWidget(),

                Gap(12),

                // телефон
                MainTextField(
                  controller: TextEditingController(),
                  label: 'Телефон',
                  hintText: 'Телефон',
                ),

                Gap(12),

                Row(
                  children: [
                    Expanded(
                      child: MainTextField(
                        controller: TextEditingController(),
                        label: 'Имя',
                        hintText: 'Иван',
                      ),
                    ),
                    Gap(12),
                    Expanded(
                      child: MainTextField(
                        controller: TextEditingController(),
                        label: 'Фамилия',
                        hintText: 'Иванов',
                      ),
                    ),
                  ],
                ),

                Gap(24),

                // Комментарий к клиенту
                GestureDetector(
                  onTap: () {
                    setState(
                      () =>
                          _isCommentClientExpanded = !_isCommentClientExpanded,
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
                  ),
                ],
                Gap(16),
              ],
            ),
          ),

          Gap(20),

          DefaultContainerWidget(
            borderRadius: BorderRadius.circular(24),
            hasShadow: false,

            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('О клиенте', style: AppFonts.b1Medium),

                Gap(12),

                Row(
                  children: [
                    Expanded(
                      child: DefaultContainerWidget(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(16),
                        hasShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Баланс', style: AppFonts.c1Medium),
                            Gap(8),
                            Text(
                              '143₽',
                              style: AppFonts.b1Medium.copyWith(
                                color: AppColors.mainAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(12),
                    Expanded(
                      child: DefaultContainerWidget(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(16),
                        hasShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('КНК', style: AppFonts.c1Medium),
                            Gap(8),
                            Text(
                              '10%',
                              style: AppFonts.b1Medium.copyWith(
                                color: AppColors.mainAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(12),

                    Expanded(
                      child: DefaultContainerWidget(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(16),
                        hasShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Визитов', style: AppFonts.c1Medium),
                            Gap(8),
                            Text(
                              '12',
                              style: AppFonts.b1Medium.copyWith(
                                color: AppColors.mainAccent,
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
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(16),
                        hasShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Скидка', style: AppFonts.c1Medium),
                            Gap(8),
                            Text(
                              '5%',
                              style: AppFonts.b1Medium.copyWith(
                                color: AppColors.mainAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(12),
                    Expanded(
                      child: DefaultContainerWidget(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(16),
                        hasShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Средний чек', style: AppFonts.c1Medium),
                            Gap(8),
                            Text(
                              '2 400₽',
                              style: AppFonts.b1Medium.copyWith(
                                color: AppColors.mainAccent,
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

          DefaultContainerWidget(
            borderRadius: BorderRadius.circular(24),
            hasShadow: false,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Специалист и услуги', style: AppFonts.b1Medium),
                Gap(16),
                Text('Специалист', style: AppFonts.c1Medium),
                Gap(8),
                DropdownButtonFormField<int>(
                  initialValue: selectedSpecialistId,
                  isExpanded: true,
                  style: AppFonts.c1Regular.copyWith(color: Colors.black),
                  hint: Text(
                    workersAsync.isLoading
                        ? 'Загрузка специалистов...'
                        : 'Выберите специалиста',
                    style: AppFonts.c1Regular.copyWith(color: Colors.black),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondaryLight,
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
                  icon: Image.asset(AppImages.arrowOutlinedDown),
                  items: specialists
                      .map(
                        (specialist) => DropdownMenuItem<int>(
                          value: specialist.id,
                          child: _SpecialistDropdownTile(
                            fullName: specialist.fullName,
                            avatarUrl: specialist.avatarUrl,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: specialists.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedSpecialistId = value;
                            for (final service in _services) {
                              service.selectedServiceId = null;
                              service.durationMinutes = 10;
                              service.selectedTime = null;
                            }
                          });
                        },
                ),
                Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дата', style: AppFonts.c1Medium),
                    GestureDetector(
                      onTap: _pickDate,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 120,
                        child: DefaultContainerWidget(
                          color: AppColors.secondaryLight,
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
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              Image.asset(
                                AppImages.calendarTab,
                                width: 18,
                                height: 18,
                                color: AppColors.mainAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                for (var index = 0; index < _services.length; index++) ...[
                  const Divider(height: 32, color: AppColors.tetriaryLight),
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
                        child: DropdownButtonFormField<int>(
                          initialValue: _services[index].selectedServiceId,
                          isExpanded: true,
                          style: AppFonts.c1Regular.copyWith(
                            color: Colors.black,
                          ),
                          hint: Text(
                            selectedSpecialistId == null
                                ? 'Сначала выберите специалиста'
                                : (workerServicesAsync.isLoading
                                      ? 'Загрузка услуг...'
                                      : 'Название услуги'),
                            style: AppFonts.c1Regular.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.secondaryLight,
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
                          icon: Image.asset(AppImages.arrowOutlinedDown),
                          items: workerServices
                              .map(
                                (service) => DropdownMenuItem<int>(
                                  value: service.id,
                                  child: Text(
                                    service.service.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.c1Regular.copyWith(
                                      color: Colors.black,
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
                                    _services[index].selectedServiceId = value;
                                    if (selected != null) {
                                      _services[index].durationMinutes =
                                          selected.duration;
                                    }
                                  });
                                },
                        ),
                      ),
                      const Gap(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          () {
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
                          }(),
                          style: AppFonts.c1Medium.copyWith(
                            color: AppColors.mainAccent,
                          ),
                        ),
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
                    Center(child: Text('Утро', style: AppFonts.c1Regular)),
                    const Gap(8),
                    Row(
                      children: [
                        for (final time in const [
                          '9:00',
                          '10:00',
                          '11:00',
                          '12:00',
                        ]) ...[
                          Expanded(
                            child: _buildTimeChip(
                              time,
                              isSelected: _services[index].selectedTime == time,
                              onTap: () {
                                setState(
                                  () => _services[index].selectedTime = time,
                                );
                              },
                            ),
                          ),
                          if (time != '12:00') const Gap(8),
                        ],
                      ],
                    ),
                    const Gap(12),
                    Center(child: Text('День', style: AppFonts.c1Regular)),
                    const Gap(8),
                    Row(
                      children: [
                        for (final time in const [
                          '13:00',
                          '14:00',
                          '15:00',
                          '16:00',
                        ]) ...[
                          Expanded(
                            child: _buildTimeChip(
                              time,
                              isSelected: _services[index].selectedTime == time,
                              onTap: () {
                                setState(
                                  () => _services[index].selectedTime = time,
                                );
                              },
                            ),
                          ),
                          if (time != '16:00') const Gap(8),
                        ],
                      ],
                    ),
                    const Gap(12),
                    Center(child: Text('Вечер', style: AppFonts.c1Regular)),
                    const Gap(8),
                    Row(
                      children: [
                        for (final time in const [
                          '17:00',
                          '18:00',
                          '19:00',
                          '20:00',
                        ]) ...[
                          Expanded(
                            child: _buildTimeChip(
                              time,
                              isSelected: _services[index].selectedTime == time,
                              onTap: () {
                                setState(
                                  () => _services[index].selectedTime = time,
                                );
                              },
                            ),
                          ),
                          if (time != '20:00') const Gap(8),
                        ],
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${_services[index].durationMinutes} минут',
                          style: AppFonts.c1Regular,
                        ),
                        const Gap(12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
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
                              Container(
                                width: 1,
                                height: 20,
                                color: AppColors.tetriaryLight,
                              ),
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
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Добавить услугу',
                              style: AppFonts.c1Semi.copyWith(
                                color: AppColors.mainAccent,
                              ),
                            ),
                            const Gap(8),
                            const Text(
                              '+',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.mainAccent,
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
            ),
          ),
          const Gap(20),
          DefaultContainerWidget(
            borderRadius: BorderRadius.circular(24),
            hasShadow: false,
            color: Colors.white,
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
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppImages.solidFull),
                      const Gap(6),
                      Text(
                        'Админ',
                        style: AppFonts.c1Regular.copyWith(color: Colors.black),
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

class _BottomActionsBar extends StatelessWidget {
  const _BottomActionsBar();

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 38, top: 20),
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: DefaultContainerWidget(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(16),
                  hasShadow: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Скидка:', style: AppFonts.c1Regular),
                      const Gap(6),
                      Text(
                        '10%',
                        style: AppFonts.c1Semi.copyWith(
                          color: AppColors.mainAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: DefaultContainerWidget(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(16),
                  hasShadow: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Итого:', style: AppFonts.c1Regular),
                      const Gap(6),
                      Text(
                        '4 400₽',
                        style: AppFonts.c1Semi.copyWith(
                          color: AppColors.mainAccent,
                        ),
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
            onTap: () {},
            color: AppColors.secondaryLight,
            textColor: AppColors.mainAccent,
          ),
          const Gap(12),
          MainButton(title: 'Сохранить и закрыть', onTap: () {}),
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

  int? selectedServiceId;
  bool isTimeExpanded = true;
  String? selectedTime;
  int durationMinutes = 10;
}

class _SpecialistDropdownTile extends StatelessWidget {
  const _SpecialistDropdownTile({required this.fullName, this.avatarUrl});

  final String fullName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SpecialistAvatar(avatarUrl: avatarUrl),
        const Gap(10),
        Expanded(
          child: Text(
            fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.c1Regular.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey),
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl!,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          ),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryDark),
      ),
    );
  }
}
