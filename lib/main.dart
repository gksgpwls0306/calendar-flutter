import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase(); //db 생성

  GetIt.I.registerSingleton<LocalDatabase>(database); // GetIt에 db 변수 주입

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
