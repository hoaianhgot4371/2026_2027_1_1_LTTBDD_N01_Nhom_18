import 'package:flutter/material.dart';

class LanguageScope extends InheritedWidget {
  const LanguageScope({
    super.key,
    required this.english,
    required this.toggle,
    required super.child,
  });
  final bool english;
  final VoidCallback toggle;
  static LanguageScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LanguageScope>();
  @override
  bool updateShouldNotify(LanguageScope oldWidget) =>
      english != oldWidget.english;
}

extension AppTranslation on BuildContext {
  String tr(String vietnamese, String english) =>
      LanguageScope.maybeOf(this)?.english == true ? english : vietnamese;
}
