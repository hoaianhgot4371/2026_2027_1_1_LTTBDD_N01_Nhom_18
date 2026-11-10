import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'language.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _english = false;
  @override
  Widget build(BuildContext context) => LanguageScope(
    english: _english,
    toggle: () => setState(() => _english = !_english),
    child: MaterialApp(
      title: 'Nhịp Sống',
      debugShowCheckedModeBanner: false,
      locale: Locale(_english ? 'en' : 'vi'),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF247568)),
        scaffoldBackgroundColor: const Color(0xFFF5F8F6),
      ),
      home: const HomeScreen(),
    ),
  );
}
