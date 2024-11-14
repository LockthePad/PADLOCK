import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/student/pull_notes_api.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';
import 'package:padlock_tablet/widgets/student/noteSavingWidget/note_saving_card.dart';
import 'package:padlock_tablet/widgets/student/noteSavingWidget/note_detail_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final storage = const FlutterSecureStorage();
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      setState(() => isLoading = true);

      String? token = await storage.read(key: 'accessToken');
      if (token != null) {
        final fetchedNotes = await NoteApi.fetchNotes(token: token);
        setState(() {
          notes = fetchedNotes;
          isLoading = false;
        });
      } else {
        throw Exception('Token not found');
      }
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        notes = [];
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필기를 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  Future<void> _deleteNote(int index, int ocrId) async {
    try {
      String? token = await storage.read(key: 'accessToken');
      debugPrint('Attempting to delete note with token: $token'); // 토큰 확인용 로그
      debugPrint('Deleting note with ocrId: $ocrId'); // ocrId 확인용 로그

      if (token != null) {
        final success = await NoteApi.deleteNote(
          token: token,
          ocrId: ocrId,
        );

        debugPrint('Delete API response success: $success'); // API 응답 확인용 로그

        if (success) {
          setState(() {
            notes.removeAt(index);
          });
          Navigator.pop(context); // 모달 닫기
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('필기 삭제에 실패했습니다.')),
            );
          }
        }
      } else {
        debugPrint('Token is null!'); // 토큰이 null인 경우 확인
        throw Exception('Token not found');
      }
    } catch (e) {
      print('Error deleting note: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필기 삭제 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  void _showNoteDetail(int index) {
    setState(() {
      selectedCardIndex = index;
    });

    final note = notes[index];
    final noteData = note.toSavingNote();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoteDetailModal(
        content: noteData['content'] as String,
        timestamp: noteData['timestamp'] as String,
        ocrId: noteData['ocrId'],
        onDelete: () => _deleteNote(index, note.ocrId),
      ),
    ).then((_) {
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
          const StuTitleWidget(title: '저장한 필기'),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : notes.isEmpty
                    ? const Center(child: Text('저장된 필기가 없습니다.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          final noteData = note.toSavingNote();
                          return NoteSavingCard(
                            content: noteData['content'] as String,
                            timestamp: noteData['timestamp'] as String,
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
