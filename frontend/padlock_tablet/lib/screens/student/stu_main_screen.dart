import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/common/current_period_api.dart';
import 'package:padlock_tablet/api/common/mealInfo_api.dart';
import 'package:padlock_tablet/api/student/timetable_api.dart';
import 'package:padlock_tablet/models/students/app_info.dart';
import 'package:padlock_tablet/models/students/meal_info.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/header_widget.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/menu_item.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/left_app_bar_widget.dart';
import 'package:padlock_tablet/widgets/student/stu_home_widget.dart';
import 'package:padlock_tablet/widgets/student/stu_mealInfo_widget.dart';
import 'package:padlock_tablet/widgets/student/stu_note_convert.dart';
import 'package:padlock_tablet/widgets/student/stu_notification_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:padlock_tablet/widgets/student/stu_saving_note_widget.dart';

class StuMainScreen extends StatefulWidget {
  const StuMainScreen({super.key});

  @override
  State<StuMainScreen> createState() => _StuMainScreenState();
}

class _StuMainScreenState extends State<StuMainScreen> {
  MenuItemStu _selectedItem = MenuItemStu.home;
  XFile? _capturedPicture;
  late MealInfo meal;
  late CurrentPeriodInfo currentClass;
  final storage = const FlutterSecureStorage();
  List<TimeTableItem> todayTimeTable = [];

  @override
  void initState() {
    super.initState();
    meal = MealInfo(dishes: ['급식 정보가 없습니다.']);
    currentClass = CurrentPeriodInfo(
      date: '로딩중...',
      period: '',
      subject: '',
      backgroundColor: AppColors.grey,
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchSelectedMealDetail(DateTime.now());
    await _fetchTodayTimeTable();
    await _fetchCurrentPeriod();
  }

  Future<void> _fetchCurrentPeriod() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final currentPeriod = await CurrentPeriodApi.fetchCurrentPeriod(
          token: accessToken,
          classroomId: classroomId!,
        );

        setState(() {
          currentClass = currentPeriod;
        });
      }
    } catch (e) {
      print('Error loading current period: $e');
      // 에러 시 기본값 설정
      setState(() {
        currentClass = CurrentPeriodInfo(
          date:
              '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
          period: '오류',
          subject: '발생',
          backgroundColor: AppColors.grey,
        );
      });
    }
  }

  Future<void> _fetchSelectedMealDetail(DateTime selectedDate) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final formattedDate = DateFormat('yyyyMMdd').format(selectedDate);

        final mealDetail = await MealinfoApi.fetchDailyMeal(
          token: accessToken,
          today: formattedDate,
          classroomId: classroomId!,
        );

        setState(() {
          meal = MealInfo(
            dishes: mealDetail['menu'].split(','),
          );
        });
      }
    } catch (e) {
      print('Error loading meal detail: $e');
      setState(() {
        meal = MealInfo(
          dishes: ['급식 정보가 없습니다.'],
        );
      });
    }
  }

  Future<void> _fetchTodayTimeTable() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final schedules = await TimetableApi.fetchSchedules(
          token: accessToken,
          classroomId: classroomId!,
        );

        // 오늘 요일 구하기 (월=MON, 화=TUE, ...)
        final today = DateFormat('E').format(DateTime.now()).toUpperCase();

        // 오늘 날짜의 시간표만 필터링
        final todaySchedules =
            schedules.where((schedule) => schedule['day'] == today).toList();

        // 교시 순으로 정렬
        todaySchedules.sort((a, b) => a['period'].compareTo(b['period']));

        setState(() {
          todayTimeTable = todaySchedules
              .map((schedule) => TimeTableItem(
                    period: '${schedule['period']}교시',
                    subject: schedule['subject'],
                  ))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading timetable: $e');
      setState(() {
        todayTimeTable = []; // 에러 시 빈 시간표
      });
    }
  }

  // 테스트 데이터
  // final CurrentPeriodInfo currentClass = CurrentPeriodInfo(
  //   date: '2024년 10월 22일 화요일',
  //   period: '1교시',
  //   subject: '국어',
  //   backgroundColor: AppColors.yellow,
  // );

  // 시간표 테스트 데이터
  final List<TimeTableItem> timeTable = [
    TimeTableItem(period: '1교시', subject: '과학'),
    TimeTableItem(period: '2교시', subject: '수학'),
    TimeTableItem(period: '3교시', subject: '영어'),
    TimeTableItem(period: '4교시', subject: '음악'),
    TimeTableItem(period: '5교시', subject: '사회'),
  ];

  final List<AppInfo> availableApps = [
    AppInfo(
      name: 'Flipnote',
      iconData: Icons.edit_note, // 노트 아이콘
      backgroundColor: Colors.red,
    ),
    AppInfo(
      name: 'Wear',
      iconData: Icons.watch, // 시계 아이콘
      backgroundColor: Colors.blue,
    ),
    AppInfo(
      name: 'Galaxy Shop',
      iconData: Icons.shopping_bag, // 쇼핑백 아이콘
      backgroundColor: Colors.blue,
    ),
  ];

  void _handlePictureTaken(XFile picture) {
    setState(() {
      _selectedItem = MenuItemStu.boardToText;
      _capturedPicture = picture;
    });
  }

  void _navigateToMealInfo() {
    setState(() {
      _selectedItem = MenuItemStu.mealInfo;
    });
  }

  void _navigateToNotice() {
    setState(() {
      _selectedItem = MenuItemStu.notification;
    });
  }

  // Add test data for saved notes
  final List<Map<String, dynamic>> testSavedNotes = [
    {
      'content':
          '동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리 나라 만세',
      'timestamp': '2024.11.06 수요일 2교시 국어시간'
    },
    {'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○', 'timestamp': '2024.11.06 09:07'},
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
    {
      'content': '자리 바꾸고 싶어요○○○○○○○○○○○○○○○○',
      'timestamp': '2024.10.23 10:59 정석영'
    },
  ];

  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItemStu.home:
        return StuHomeWidget(
          currentClass: currentClass,
          timeTable: todayTimeTable,
          meal: meal,
          availableApps: availableApps,
          onPictureTaken: _handlePictureTaken,
          onViewMealDetail: _navigateToMealInfo,
          onViewNotice: _navigateToNotice,
        );
      case MenuItemStu.notification:
        return const Center(child: StuNotificationWidget());
      case MenuItemStu.boardToText:
        return Center(
          child: StuNoteConvertWidget(
            picture: _capturedPicture,
            onPictureTaken: _handlePictureTaken, // 동일한 콜백 전달
          ),
        );
      case MenuItemStu.savingNotes:
        return Center(
            child: StuSavingNoteWidget(
          savingNotes: testSavedNotes,
        ));
      case MenuItemStu.mealInfo:
        return const Center(
          child: StuMealinfoWidget(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            LeftAppBarWidget(
              selectedItem: _selectedItem,
              onItemSelected: (MenuItemStu newItem) {
                setState(() {
                  _selectedItem = newItem;
                });
              },
            ),
            // const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  const HeaderWidget(
                    userName: "정석영",
                    userClass: "대전초 2학년 2반",
                    isStudent: true,
                  ),
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
