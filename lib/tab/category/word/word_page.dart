import 'package:flutter/material.dart';

class WordPage extends StatefulWidget {
  const WordPage({Key? key}) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  final List<WordCard> words = [
    WordCard('Flutter', '플러터', 'Flutter is a UI toolkit.'),
    WordCard('Dart', '다트', 'Dart is a programming language.'),
    WordCard('Professor', '교수님', null),
    WordCard('win', '이기다', null),
    // 나중에 단어 데이터로 받아오는 건 처리 예정
  ];

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var word in words)
              Column(
                children: [
                  WordCardItem(wordCard: word),
                  const SizedBox(height: 16),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_document, color: Colors.white),
                  onPressed: () {
                    // 첫 번째 아이콘 버튼 동작 추가
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  onPressed: () {
                    // 두 번째 아이콘 버튼 동작 추가
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
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
