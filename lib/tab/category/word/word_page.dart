import 'package:flutter/material.dart';

class WordPage extends StatefulWidget {
  const WordPage({Key? key}) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  final List<WordCard> words = [
    WordCard('Flutter', '플러터', 'Flutter is a UI toolkit.'),
    WordCard('Dart', '다트', 'Dart is a programming language.'), //예문이 있는 예시
    WordCard('Professor', '교수님', null), //예문이 없는 예시
    WordCard('win', '이기다', null),
    WordCard('test', '시험', null),
    WordCard('Student', '학생', null),
    WordCard('Dart', '다트', 'Dart is a programming language.'), //예문이 있는 예시
    WordCard('Professor', '교수님', null), //예문이 없는 예시
    WordCard('win', '이기다', null),
    WordCard('test', '시험', null),
    // 나중에 단어 데이터로 받아오는 건 처리 예정
  ];

  final int cardsPerPage = 5;
  int currentPage = 0;

  List<List<WordCard>> _groupWords() {
    List<List<WordCard>> grouped = [];
    for (int i = 0; i < words.length; i += cardsPerPage) {
      grouped.add(words.sublist(i, i + cardsPerPage));
    }
    //print('Grouped words length: ${grouped.length}');
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    List<List<WordCard>> groupedWords = _groupWords();
    // 첫 번째 그룹의 요소들 확인
    /*for (var word in groupedWords[0]) {
      print('First Group: ${word.word}, ${word.meaning}, ${word.example}');
    }

    // 두 번째 그룹의 요소들 확인
    for (var word in groupedWords[1]) {
      print('Second Group: ${word.word}, ${word.meaning}, ${word.example}');
    } */

    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // 카테고리 버튼 동작 추가
          },
        ),
        title: const Text(
          'VOCA',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: groupedWords.length,
              physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
              itemBuilder: (context, pageIndex) {
                final pageWords = groupedWords[pageIndex];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var word in pageWords)
                        Column(
                          children: [
                            WordCardItem(wordCard: word),
                            const SizedBox(height: 16),
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
// 단어 리스트는 잘 나눠지는데 페이지를 넘겼을때 상태가 변하지 않는 문제 추후 해결 예정
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                  /*print('Current Page: $currentPage'); 
                  페이지가 잘 넘어가는지 확인하는 부분 -> 디버그 콘솔에 출력 안됨 */
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_document,
                    color: Colors.white70, size: 50),
                onPressed: () {
                  // 단어시험 아이콘 버튼 동작 추가
                },
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: Colors.white70, size: 50),
                onPressed: () {
                  // 단어추가 아이콘 버튼 동작 추가
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < groupedWords.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      currentPage = i;
                      print('Tapped Page: $currentPage');
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == currentPage
                          ? const Color(0xFFBCC7EF)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF5C65BB),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (i + 1).toString(),
                        style: TextStyle(
                          color: i == currentPage
                              ? const Color(0xFF5C65BB)
                              : const Color(0xFF5C65BB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class WordCard {
  final String word;
  final String meaning;
  final String? example;

  WordCard(this.word, this.meaning, this.example);
}

class WordCardItem extends StatefulWidget {
  final WordCard wordCard;

  const WordCardItem({Key? key, required this.wordCard}) : super(key: key);

  @override
  _WordCardItemState createState() => _WordCardItemState();
}

class _WordCardItemState extends State<WordCardItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _isExpanded ? const Color(0xFFBCC7EF) : const Color(0xFF5C65BB),
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.wordCard.word,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(widget.wordCard.meaning),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded && widget.wordCard.example != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.wordCard.example!),
            ),
        ],
      ),
    );
  }
}
