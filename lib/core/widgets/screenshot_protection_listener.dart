import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/screenshot_protection_service.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';

/// Включает/отключает защиту от скриншотов при смене роли (owner — разрешено).
class ScreenshotProtectionListener extends ConsumerStatefulWidget {
  const ScreenshotProtectionListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ScreenshotProtectionListener> createState() =>
      _ScreenshotProtectionListenerState();
}

class _ScreenshotProtectionListenerState
    extends ConsumerState<ScreenshotProtectionListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncProtection());
  }

  void _syncProtection() {
    if (!mounted) return;
    unawaited(
      ScreenshotProtectionService.applyForRole(ref.read(roleProvider)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(roleProvider, (previous, next) {
      if (previous == next) return;
      unawaited(ScreenshotProtectionService.applyForRole(next));
    });

    return widget.child;
  }
}
