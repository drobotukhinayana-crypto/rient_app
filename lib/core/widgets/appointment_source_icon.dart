import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rient_app/features/schedule/utils/appointment_source.dart';

/// Иконка источника записи. Пустой виджет, если [source] неизвестен.
class AppointmentSourceIcon extends StatelessWidget {
  const AppointmentSourceIcon({
    super.key,
    required this.source,
    this.size = 16,
  });

  final int? source;
  final double size;

  @override
  Widget build(BuildContext context) {
    final info = appointmentSourceInfo(source);
    if (info == null) return const SizedBox.shrink();

    if (info.isSvg) {
      return SvgPicture.asset(
        info.assetPath,
        width: size,
        height: size,
      );
    }

    return Image.asset(
      info.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
