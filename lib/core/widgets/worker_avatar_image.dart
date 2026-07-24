import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rient_app/core/network/app_dio.dart';
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
      final localFile = _localImageFile(url);
      if (localFile != null) {
        return ClipOval(
          child: Image.file(
            localFile,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(context),
          ),
        );
      }
      if (!url.startsWith('file:')) {
        return ClipOval(
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            headers: const {'X-MOBILE-TOKEN': appMobileToken},
            errorBuilder: (_, __, ___) => _fallback(context),
          ),
        );
      }
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) =>
      placeholder ?? _defaultPlaceholder(context);

  static File? _localImageFile(String url) {
    String path;
    if (url.startsWith('file://')) {
      path = Uri.parse(url).toFilePath();
    } else if (url.startsWith('/')) {
      path = url;
    } else {
      return null;
    }
    final file = File(path);
    return file.existsSync() ? file : null;
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
