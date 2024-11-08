import 'package:flutter/material.dart';
import 'package:padlock_tablet/screens/common/login_screen.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/menu_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LeftAppBarWidget extends StatelessWidget {
  final MenuItemStu selectedItem;
  final Function(MenuItemStu) onItemSelected;
  final storage = const FlutterSecureStorage();

  LeftAppBarWidget({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final List<MenuItemData> _menuItems = [
    MenuItemData('홈', Icons.home_rounded, MenuItemStu.home),
    MenuItemData('공지사항', Icons.campaign_rounded, MenuItemStu.notification),
    MenuItemData('필기 변환하기', Icons.document_scanner_rounded,
        MenuItemStu.boardToText), // 또는 Icons.camera_alt_rounded
    MenuItemData('저장한 필기', Icons.folder_rounded,
        MenuItemStu.savingNotes), // 또는 Icons.note_rounded
    MenuItemData('이달의 급식', Icons.restaurant_menu_rounded, MenuItemStu.mealInfo),
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
                  'assets/stuMainLockImg.png',
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
                    color: isSelected ? AppColors.yellow : AppColors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? AppColors.yellow : AppColors.black,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.yellow.withOpacity(0.1),
                  onTap: () => onItemSelected(item.item),
                );
              },
            ),
          ),
          // 로그아웃 버튼
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: AppColors.grey,
            ),
            title: const Text('로그아웃'),
            onTap: () async {
              await storage.delete(key: "accessToken");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          SizedBox(
            height: 20,
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
