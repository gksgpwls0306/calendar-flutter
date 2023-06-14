import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';

part 'drift_database.g.dart'; // part 파일 지정

@DriftDatabase( // 사용할 테이블 등록
  tables: [
    Schedules,
  ],
)

class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
  Stream<List<Schedule>> watchScheudules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  Future<int> createSchedule(SchedulesCompanion date) =>
      into(schedules).insert(date); //새 일정 추가

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 1;
}
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

