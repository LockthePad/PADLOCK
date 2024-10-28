import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

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
                Image.asset(
                  'assets/backpack.png',
                  height: 150,
                ),
                SizedBox(
                  height: 10,
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
                  selectedTileColor: AppColors.navy,
                  onTap: () => onItemSelected(item.item),
                );
              },
            ),
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
