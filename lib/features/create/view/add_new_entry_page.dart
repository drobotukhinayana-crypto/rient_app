import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/create/view/components/client_status_selector_widget.dart';
import 'package:rient_app/resources/resources.dart';

class AddNewEntryPage extends StatelessWidget {
  const AddNewEntryPage({super.key});

  static const name = 'add_new_entry_page';
  static const path = '/add_new_entry_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  bool _isCommentVisitExpanded = true;
  bool _isCommentClientExpanded = true;
  final _commentVisitController = TextEditingController();
  final _commentClientController = TextEditingController();

  @override
  void dispose() {
    _commentVisitController.dispose();
    _commentClientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // заголовок
        DefaultContainerWidget(
          borderRadius: BorderRadius.circular(24),
          hasShadow: false,
          padding: const EdgeInsets.only(
            top: 52,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // заголовок
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(AppImages.back),
                  ),
                  Text('Новая запись', style: AppFonts.h4Medium),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(AppImages.more),
                  ),
                ],
              ),

              Gap(24),

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
                    () => _isCommentClientExpanded = !_isCommentClientExpanded,
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
      ],
    );
  }
}
