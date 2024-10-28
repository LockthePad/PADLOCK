import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/menu_item.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/left_app_bar_widget.dart';

class LeftAppBarWidget extends StatelessWidget {
  final MenuItemStu selectedItem;
  final Function(MenuItemStu) onItemSelected;

  LeftAppBarWidget({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final List<MenuItemData> _menuItems = [
    MenuItemData('홈', Icons.home_rounded, MenuItemStu.home),
    MenuItemData('공지사항', Icons.campaign_rounded, MenuItemStu.notification),
    MenuItemData('필기 변환하기', Icons.edit_note_rounded, MenuItemStu.boardToText),
    MenuItemData(
        '우리반 시간표', Icons.calendar_today_rounded, MenuItemStu.timetable),
    MenuItemData('오늘의 급식', Icons.restaurant_menu_rounded, MenuItemStu.mealInfo),
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
            child: Row(
              children: [
                // Image.asset(
                //   'assets/padlock_icon.png',
                //   width: 32,
                //   height: 32,
                // ),
                const SizedBox(width: 8),
                const Text(
                  'PADLOCK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                    color: isSelected ? Colors.orange : Colors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? Colors.orange : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.orange.withOpacity(0.1),
                  onTap: () => onItemSelected(item.item),
                );
              },
            ),
          ),
          // 로그아웃 버튼
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.grey,
            ),
            title: const Text('로그아웃'),
            onTap: () {
              // 로그아웃 처리
            },
          ),
        ],
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final MenuItemStu item;

  const MenuItemData(this.title, this.icon, this.item);
}
