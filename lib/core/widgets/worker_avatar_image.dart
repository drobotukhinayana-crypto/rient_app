import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

class WorkerAvatarImage extends StatelessWidget {
  const WorkerAvatarImage({
    super.key,
    this.pictureUrl,
    required this.name,
    this.size = 40,
    this.placeholder,
  });

  final String? pictureUrl;
  final String name;
  final double size;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final url = pictureUrl?.trim();
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('file://')) {
        final file = File(url.substring(7));
        if (file.existsSync()) {
          return ClipOval(
            child: Image.file(
              file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _defaultPlaceholder(context),
            ),
          );
        }
      } else {
        return ClipOval(
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _defaultPlaceholder(context),
          ),
        );
      }
    }
    return placeholder ?? _defaultPlaceholder(context);
  }

  Widget _defaultPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _extractInitials(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.forthLightDark : AppColors.secondaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
        ),
      ),
    );
  }

  static String _extractInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
