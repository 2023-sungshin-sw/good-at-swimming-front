import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/category_page.dart';
import 'package:good_swimming/tab/home/home_page.dart';
import 'package:good_swimming/tab/myPage/my_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key, required this.selectedTab});
  final int selectedTab;

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedTab; // 선택된 탭을 초기화
  }

  final _pages = [
    HomePage(),
    CategoryPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_currentIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color(0xFF030C1A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(0, Icons.home, 'Home'),
                  _buildTabItem(1, Icons.menu, 'Category'),
                  _buildTabItem(2, Icons.person, 'MyPage'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData iconData, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF5C65BB) : Colors.transparent,
              borderRadius: BorderRadius.circular(30), // 둥근 모서리 설정
            ),
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF5C65BB) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
