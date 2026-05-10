import 'package:flutter/material.dart';

class AppTypography {
  final BuildContext context;

  AppTypography._privateConstructor(
      {required this.context}); // Private constructor

  factory AppTypography({required BuildContext context}) {
    return AppTypography._privateConstructor(
        context: context); // Return the singleton instance
  }

  TextStyle get title1 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title2 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title3 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get heading1 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  TextStyle get bodyText => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 14,
      );

  TextStyle get subhead => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      );

  TextStyle get footnote => TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w200);
}
