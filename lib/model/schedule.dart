import 'package:drift/drift.dart';

class Schedules extends Table{
  IntColumn get id => integer().autoIncrement()(); //기본키, 정수열
  TextColumn get content => text()(); //내용, 글자열
  DateTimeColumn get date => dateTime()(); // 일정 날짜, 날짜열
  IntColumn get startTime => integer()(); //시작 시간
  IntColumn get endTime => integer()(); //종료 시간
}