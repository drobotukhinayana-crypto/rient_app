import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/network/app_vpn.dart';
import 'package:rient_app/core/network/app_vpn_provider.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

/// Тёмная плашка как в МТС: иконка, текст, «Понятно».
class VpnBanner extends ConsumerWidget {
  const VpnBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: const Color(0xFF2C2C2E),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCC00),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                appVpnActiveMessage,
                style: AppFonts.c1Medium.copyWith(
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ),
            const Gap(8),
            Container(
              width: 1,
              height: 28,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(vpnBannerDismissedThisSessionProvider.notifier)
                    .state = true;
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Понятно',
                style: AppFonts.c1Medium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
