import 'package:flutter/material.dart';

enum MenuItem { home, notification, boardToText, timetable, food }

class LeftAppBarWidget extends StatelessWidget {
  final MenuItem selectedItem;
  final Function(MenuItem) onItemSelected;

  const LeftAppBarWidget({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final List<MenuItemData> _menuItems = const [
    MenuItemData('홈', Icons.home, MenuItem.home),
    MenuItemData('공지사항', Icons.notifications, MenuItem.notification),
    MenuItemData('필기 변환하기', Icons.edit_note, MenuItem.boardToText),
    MenuItemData('우리반 시간표', Icons.calendar_today, MenuItem.timetable),
    MenuItemData('오늘의 급식', Icons.restaurant_menu, MenuItem.food),
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
