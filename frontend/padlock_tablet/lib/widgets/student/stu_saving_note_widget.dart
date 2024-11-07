import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';
import 'package:padlock_tablet/widgets/student/noteSavingWidget/note_saving_card.dart';
import 'package:padlock_tablet/widgets/student/noteSavingWidget/note_detail_modal.dart';

class StuSavingNoteWidget extends StatefulWidget {
  final List<Map<String, dynamic>> savingNotes;

  const StuSavingNoteWidget({
    super.key,
    required this.savingNotes,
  });

  @override
  State<StuSavingNoteWidget> createState() => _StuSavingNoteWidgetState();
}

class _StuSavingNoteWidgetState extends State<StuSavingNoteWidget> {
  int? selectedCardIndex;

  void _showNoteDetail(int index) {
    setState(() {
      selectedCardIndex = index;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // 모달 외부 클릭 시 닫히지 않도록 설정
      builder: (context) => NoteDetailModal(
        content: widget.savingNotes[index]['content'],
        timestamp: widget.savingNotes[index]['timestamp'],
      ),
    ).then((_) {
      // 모달이 닫힐 때 선택 상태 해제
      setState(() {
        selectedCardIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀
          const StuTitleWidget(title: '저장한 필기'),
          const SizedBox(height: 10),
          // 필기 카드 그리드
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 행에 3개의 카드
                crossAxisSpacing: 10, // 카드 사이의 가로 간격
                mainAxisSpacing: 10, // 카드 사이의 세로 간격
                childAspectRatio: 1.8, // 카드의 가로 세로 비율
              ),
              itemCount: widget.savingNotes.length,
              itemBuilder: (context, index) {
                final savingNote = widget.savingNotes[index];
                return NoteSavingCard(
                  content: savingNote['content'],
                  timestamp: savingNote['timestamp'],
                  isSelected: selectedCardIndex == index,
                  onTap: () => _showNoteDetail(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
