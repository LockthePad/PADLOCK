import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/member/member_api_service.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/screens/common/login_screen.dart';

enum MenuItem {
  home,
  notification,
  attendanceCheck,
  timetable,
  mealInfo,
  rightInfo,
  counseling
}

class LeftAppBarWidget extends StatelessWidget {
  final MenuItem selectedItem;
  final Function(MenuItem) onItemSelected;
  final storage = const FlutterSecureStorage();

  const LeftAppBarWidget({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final List<MenuItemData> _menuItems = const [
    MenuItemData('홈', Icons.home_rounded, MenuItem.home),
    MenuItemData('공지사항', Icons.campaign_rounded, MenuItem.notification),
    MenuItemData(
        '우리반 출석현황', Icons.people_alt_rounded, MenuItem.attendanceCheck),
    MenuItemData('우리반 시간표', Icons.calendar_today_rounded, MenuItem.timetable),
    MenuItemData('이번달 급식', Icons.restaurant_menu_rounded, MenuItem.mealInfo),
    MenuItemData('건의함 보기', Icons.person_rounded, MenuItem.rightInfo),
    MenuItemData(
        '학부모상담 신청현황', Icons.support_agent_rounded, MenuItem.counseling),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      width: 225,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.grey,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/backpack.png',
                  height: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                const Divider(),
              ],
            ),
          ),
          // 메뉴 리스트
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = selectedItem == item.item;

                return ListTile(
                  visualDensity: VisualDensity(vertical: -4), // 내부 밀도 조정
                  leading: Icon(
                    item.icon,
                    color: isSelected ? AppColors.navy : AppColors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? AppColors.navy : AppColors.black,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.navy.withOpacity(0.1),
                  onTap: () => onItemSelected(item.item),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: AppColors.grey,
            ),
            title: const Text('로그아웃'),
            onTap: () async {
              final refreshToken = await storage.read(key: 'refreshToken');
              if (refreshToken != null) {
                await MemberApiService().logout(refreshToken);
              }
              await storage.delete(key: "accessToken");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final MenuItem item;

  const MenuItemData(this.title, this.icon, this.item);
}
