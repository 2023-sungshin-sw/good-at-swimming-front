import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResultPage(),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int correctCount = 20; // 맞은 갯수 (임시값)
  int totalCount = 25; // 전체 문제 수 (임시값)
  int currentPage = 1; // 현재 페이지 (임시값)
  int itemsPerPage = 5; // 한 페이지에 보여줄 단어 박스 개수
  int totalPages = 2; // 총 페이지 수 (임시값)

  List<String> wrongWords = [
    'cake',
    'Professor',
    'Wrong Word 3',
    'Wrong Word 4',
    'Wrong Word 5',
    'Wrong Word 6',
    // ... 추가적인 틀린 단어
  ];

  Map<String, String> wordMeanings = {
    'cake': '케이크',
    'Professor': '교수님',
    'Wrong Word 3': '뜻 3',
    'Wrong Word 4': '뜻 4',
    'Wrong Word 5': '뜻 5',
    'Wrong Word 6': '뜻 6',
    // ... 추가적인 단어와 뜻
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: const Text(
          'VOCA',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'Player'),
        ),
      ),
      backgroundColor: const Color(0xFF030C1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 198,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color(0xFF5C65BB),
              ),
              child: Center(
                child: Text(
                  'RESULT', // 결과 타원 안의 텍스트
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Black Han Sans',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 321,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFBCC7EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$correctCount / $totalCount', // 점수 박스 (맞은 갯수 / 전체 문제 수)
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'IBM Plex Sans KR',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                itemCount: totalPages,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page + 1;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  final startIndex = (currentPage - 1) * itemsPerPage;
                  final endIndex =
                      (currentPage * itemsPerPage).clamp(0, wrongWords.length);

                  return Column(
                    children: [
                      for (int i = startIndex; i < endIndex; i++)
                        Column(
                          children: [
                            Container(
                              width: 325,
                              height: 80,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: const Color(0xFF121F33),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        wrongWords[i], // 틀린 영단어
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        wordMeanings[wrongWords[i]] ??
                                            '뜻 없음', // 영단어 뜻
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10), // 추가: 단어박스 사이 간격
                          ],
                        ),
                      SizedBox(height: 20), // 페이지 위치 조정
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              if (currentPage > 1) {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Page $currentPage', // 페이지 num
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              if (currentPage < totalPages) {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
