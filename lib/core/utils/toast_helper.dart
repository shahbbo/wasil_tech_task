import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    CherryToast.success(
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.success,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
    ).show(context);
  }

  static void showError(BuildContext context, String message) {
    CherryToast.error(
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.error,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
    ).show(context);
  }

  static void showInfo(BuildContext context, String message) {
    CherryToast.info(
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.primary,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
    ).show(context);
  }

  static void showWarning(BuildContext context, String message) {
    CherryToast.warning(
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.warning,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
    ).show(context);
  }
}
