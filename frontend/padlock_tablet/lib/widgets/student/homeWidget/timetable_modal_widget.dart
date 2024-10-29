import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class TimeTableData {
  final String day;
  final String period;
  final String subject;

  TimeTableData({
    required this.day,
    required this.period,
    required this.subject,
  });
}

class TimetableModalWidget extends StatelessWidget {
  final List<TimeTableData> timeTableData;

  const TimetableModalWidget({
    super.key,
    required this.timeTableData,
  });

  List<List<String>> _organizeTimeTable() {
    List<List<String>> organized = List.generate(
      6,
      (_) => List.filled(5, ""),
    );

    for (var data in timeTableData) {
      int dayIndex = ['월', '화', '수', '목', '금'].indexOf(data.day);
      int periodIndex = int.parse(data.period) - 1;
      if (dayIndex != -1 && periodIndex >= 0 && periodIndex < 6) {
        organized[periodIndex][dayIndex] = data.subject;
      }
    }

    return organized;
  }

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = ["월", "화", "수", "목", "금"];
    final organizedData = _organizeTimeTable();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.8,
        padding:
            const EdgeInsets.only(left: 36, right: 24, top: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // Stack 영역을 벗어나도 잘리지 않도록
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10), // 이미지가 위로 올라갈 공간 확보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 60), // 이미지 공간만큼 여백
                        const Text(
                          "우리반 시간표",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 110,
                  top: 0, // 위로 올라가는 정도
                  child: Image(
                    image: const AssetImage('assets/calendar.png'),
                    width: 70, // 더 크게
                    height: 70, // 더 크게
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: -12,
                  top: -12,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        ...List.generate(
                          5,
                          (index) => Expanded(
                            child: Container(
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      dayOfWeek[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              itemBuilder: (context, periodIndex) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: periodIndex < 5
                                          ? BorderSide(color: AppColors.yellow)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.yellow,
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${periodIndex + 1}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: AppColors.yellow,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: List.generate(
                                            5,
                                            (dayIndex) => Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: dayIndex < 4
                                                        ? BorderSide(
                                                            color: AppColors
                                                                .yellow)
                                                        : BorderSide.none,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    organizedData[periodIndex]
                                                        [dayIndex],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      // fontWeight:
                                                      //     FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
