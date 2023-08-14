import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/word/create_page.dart';
import 'package:good_swimming/tab/category/word/test_page.dart';
import 'package:good_swimming/tab/tab_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordPage extends StatefulWidget {
  const WordPage({Key? key}) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  List<WordCard> words = [];
  final int cardsPerPage = 5;
  List<List<bool>> cardExpandedStates = []; //토글 상태 리스트 페이지별로 관리하도록 수정

  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<GlobalKey<_WordCardItemState>> cardItemKeys = [];

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    final response = await http
        .get(Uri.parse('http://www.good-at-swimming-back.store/words?id=1'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      //print(data);
      List<WordCard> fetchedWords = [];
      for (var item in data) {
        fetchedWords.add(
          WordCard(
            item['word'],
            item['meaning'],
            item['example_en'],
            item['example_kr'],
          ),
        );
      }

      setState(() {
        words = fetchedWords;
        for (var _ in words) {
          cardItemKeys.add(GlobalKey<_WordCardItemState>());
        }
      });
    } else {
      // 오류 처리
      print('단어 가져오기 실패');
    }
  }

  List<List<WordCard>> _groupWords() {
    List<List<WordCard>> grouped = [];
    int startIndex = 0;

    while (startIndex < words.length) {
      final endIndex = startIndex + cardsPerPage;
      final sublist =
          words.sublist(startIndex, endIndex.clamp(0, words.length));
      if (sublist.isNotEmpty) {
        // 빈 리스트인 경우 그룹 추가를 방지
        grouped.add(sublist);
      }
      startIndex = endIndex;
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    List<List<WordCard>> groupedWords = _groupWords();

    /* void resetAllExpandedStates() {
      for (var key in cardItemKeys) {
        key.currentState?.collapse();
      }
    }*/

    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TabPage(selectedTab: 1)),
            );
          },
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
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int pageIndex) {
                if (groupedWords.isNotEmpty) {
                  setState(() {
                    currentPage = pageIndex;
                    //resetAllExpandedStates();
                  });
                }
              },
              children: List<Widget>.generate(groupedWords.length, (pageIndex) {
                final pageWords = groupedWords[currentPage];

                return ListView(
                  children: [
                    for (var word in pageWords)
                      Column(
                        children: [
                          WordCardItem(wordCard: word),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ],
                );
              }),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: Colors.white70, size: 50),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < groupedWords.length; i++)
                if (i < groupedWords.length)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        currentPage = i;
                        //resetAllExpandedStates();
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
  final String? example_en;
  final String? example_kr;

  WordCard(this.word, this.meaning, this.example_en, this.example_kr);
  @override
  String toString() {
    return 'WordCard{word: $word, meaning: $meaning, example_en: $example_en, example_kr: $example_kr}';
  }
}

class WordCardItem extends StatefulWidget {
  final WordCard wordCard;

  const WordCardItem({Key? key, required this.wordCard}) : super(key: key);

  @override
  _WordCardItemState createState() => _WordCardItemState();
}

class _WordCardItemState extends State<WordCardItem> {
  bool _isExpanded = false;

  /*void collapse() {
    setState(() {
      _isExpanded = false;
    });
  }*/

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
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.wordCard.example_en != null)
                    Text(widget.wordCard.example_en!),
                  if (widget.wordCard.example_kr != null)
                    Text(widget.wordCard.example_kr!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
