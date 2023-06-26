import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

final _base = ThemeData.light();
final lightTheme = _base.copyWith(
  backgroundColor: AppColors.lightWhite100,
  textTheme: _base.textTheme.copyWith(
    headline1: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBlack100,
    ),
    headline2: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBlack100,
    ),
    headline3: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: AppColors.darkBlack100,
    ),
    headline4: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: AppColors.darkBlack100,
    ),
    headline5: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkBlack100,
    ),
    caption: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.darkBlack100,
    ),
    button: const TextStyle(
      fontSize: 14,
      height: 1.15,
      fontWeight: FontWeight.w700,
      color: AppColors.lightBlack100,
    ),
  ),
);
