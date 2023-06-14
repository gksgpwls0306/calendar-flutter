import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' hide Column; // material.dart의 Column과 겹쳐서 숨기기
import 'package:get_it/get_it.dart';


class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: formKey,
      child: SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2 +
            bottomInset, // ➋ 화면 반 높이에 키보드 높이 추가하기
        color: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
          child: Column(
            // ➋ 시간 관련 텍스트 필드와 내용관련 텍스트 필드 세로로 배치
            children: [
              Row(
                // ➊ 시작 시간 종료 시간 가로로 배치
                children: [
                  Expanded(
                    child: CustomTextField(
                      // 시작시간 입력 필드
                      label: '시작 시간',
                      isTime: true,
                      onSaved: (String? val){
                        startTime = int.parse(val!);
                      },
                      validator: timeValidator,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      // 종료시간 입력 필드
                      label: '종료 시간',
                      isTime: true,
    onSaved: (String? val){
                        endTime = int.parse(val!);
    },
    validator: contentValidator,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: CustomTextField(
                  // 내용 입력 필드
                  label: '내용',
                  isTime: false,
                  onSaved: (String? val){
                    content = val;
                  },
                  validator: contentValidator,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // [저장] 버튼
                  // ➌ [저장] 버튼
                  onPressed: onSavePressed,
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );

  }

  void onSavePressed() async {
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();

      await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDate),
        ),
      );
      Navigator.of(context).pop(); // 일정
    }
  }
  String? timeValidator(String? val){ // 시간 검증 함수
    if(val == null){
      return '값을 입력해주세요';
    }
    int? number;
    try{
      number = int.parse(val);
    }catch(e){
      return '숫자를 입력해주세요';
    }

    if(number < 0 || number > 24){
      return '0시부터 24시 사이를 입력해주세요';
    }
    return null;
  }
  String? contentValidator(String? val){
    if(val == null || val.length == 0){
      return '값을 입력해주세요';
    }
    return null;
  }
}
