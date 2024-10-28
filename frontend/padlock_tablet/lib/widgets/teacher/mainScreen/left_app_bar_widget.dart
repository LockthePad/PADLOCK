import 'package:flutter/material.dart';

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
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // 로고 영역
          Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                // 이곳에 피그마 이미지가 들어가야 합니다.
                SizedBox(width: 8),
                Text(
                  'PADLOCKIMAGE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF353B66),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
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
                    color: isSelected ? const Color(0xFF353B66) : Colors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color:
                          isSelected ? const Color(0xFF353B66) : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: const Color(0xFF353B66).withOpacity(0.1),
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
