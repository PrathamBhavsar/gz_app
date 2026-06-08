import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_exception.dart';

void showErrorSnackbar(BuildContext context, Object error) {
  final pageError = AppPageError.from(error);
  _showSnackbar(
    context,
    message: pageError.message,
    backgroundColor: AppColors.err,
    textColor: AppColors.buttonFg,
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  _showSnackbar(
    context,
    message: message,
    backgroundColor: AppColors.ok,
    textColor: AppColors.buttonFg,
  );
}

void _showSnackbar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  required Color textColor,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    return;
  }

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
