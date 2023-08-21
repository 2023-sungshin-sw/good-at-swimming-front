import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            SizedBox(
              width: 400, // 원하는 가로 크기
              height: 300, // 원하는 세로 크기
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: const Color(0xFF5C65BB),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '오늘의 영어 표현',
                        style: TextStyle(
                          fontFamily: 'QQ',
                          color: Colors.white,
                          fontSize: 30,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Tomorrow hopes we have learned \nsomething from yesterday.', // 영어 표현 한문장
                        style: TextStyle(
                            fontFamily: 'QQ',
                            letterSpacing: 2.0,
                            height: 1.5,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '내일은 우리가 어제로부터 \n무엇인가 배웠기를 바란다.', // 한국말 해석
                        style: TextStyle(
                            fontFamily: 'QQ',
                            letterSpacing: 2.0,
                            height: 1.5,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/수룡.png', // 이미지 파일
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
