import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:rient_app/core/providers/locale_provider.dart';
import 'package:rient_app/core/providers/theme_mode_provider.dart';
import 'package:rient_app/core/routes/router_provider.dart';
import 'package:rient_app/core/widgets/app_lock_listener.dart';
import 'package:rient_app/core/widgets/screenshot_protection_listener.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final _supportedLocales = [
  Locale('az'),
  Locale('be'),
  Locale('en'),
  Locale('hy'),
  Locale('kk'),
  Locale('ky'),
  Locale('ru'),
  Locale('ro'),
  Locale('tg'),
  Locale('uk'),
  Locale('uz'),
];

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final effectiveBrightness = switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };
    final isDark = effectiveBrightness == Brightness.dark;
    final statusBarColor = isDark
        ? AppColors.primaryWhiteDark
        : AppColors.primaryWhite;
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: statusBarColor,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );

    return ScreenshotProtectionListener(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: _supportedLocales,
          locale: locale,
          themeMode: themeMode,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.primaryWhite,
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.mainAccent),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: AppColors.primaryWhiteDark,
            colorScheme: ColorScheme.dark(
              primary: AppColors.mainAccentDark,
              surface: AppColors.secondaryLightDark,
            ),
          ),
          debugShowCheckedModeBanner: false,
          key: navigatorKey,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          builder: (context, child) {
            return AppLockListener(
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
