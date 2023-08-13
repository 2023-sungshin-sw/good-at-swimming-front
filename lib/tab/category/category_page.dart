import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/speaking/speaking_page.dart';
import 'package:good_swimming/tab/category/translation/translation_page.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton(
                  context,
                  Icons.translate,
                  'TRANSLATE',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TranslatePage()),
                    );
                  },
                ),
                const SizedBox(width: 20),
                _buildCategoryButton(
                  context,
                  Icons.record_voice_over,
                  'SPEAKING',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SpeakingPage()),
                    );
                  },
                ),
                const SizedBox(width: 20),
                _buildCategoryButton(
                  context,
                  Icons.abc,
                  'VOCA',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WordPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30), // 이미지와 박스 간 간격 조정
            Image.asset(
              'assets/수룡.png', // 이미지 파일 경로
              width: 400, // 이미지 너비 조정
              height: 250, // 이미지 높이 조정
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, IconData iconData,
      String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF5C65BB), // 박스 색상 설정
          borderRadius: BorderRadius.circular(25), // 둥근 모서리 설정
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
