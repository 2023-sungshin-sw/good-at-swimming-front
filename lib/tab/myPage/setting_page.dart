import 'package:flutter/material.dart';
import 'package:good_swimming/tab/myPage/my_page.dart';
import 'package:good_swimming/tab/tab_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingPage(),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TabPage(selectedTab: 2)),
            );
          },
        ),
        title: const Text(
          'SETTING',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'En'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20), // 상단 간격
          _buildButton(context, '비밀번호 변경', () {
            // 비밀번호 변경 화면으로 이동 (기능 구현 필요)
          }),
          const SizedBox(height: 20), // 버튼 간격
          _buildButton(context, '로그아웃', () {
            // 로그아웃 화면으로 이동 (기능 구현 필요)
          }),
          const SizedBox(height: 20), // 버튼 간격
          _buildButton(context, '고객의 소리', () {
            // 고객의 소리 화면으로 이동 (기능 구현 필요)
          }),
          const SizedBox(height: 20), // 버튼 간격
          _buildButton(context, '회원탈퇴', () {
            // 회원탈퇴 화면으로 이동 (기능 구현 필요)
          }),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF121F33), // 버튼 배경색
        onPrimary: Colors.white, // 텍스트 색상
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        minimumSize: Size(200, 48),
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Kr'),
      ),
    );
  }
}
