import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreatePage(),
    );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();

  List<WordData> _wordDataList = [];

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
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFF030C1A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _buildInputField(
              controller: _wordController,
              labelText: 'ENGLISH',
              hintText: '영단어를 입력해주세요',
            ),
            SizedBox(height: 40),
            _buildInputField(
              controller: _meaningController,
              labelText: 'KOREAN',
              hintText: '뜻을 입력해주세요',
            ),
            SizedBox(height: 40),
            _buildInputField(
              controller: _exampleController,
              labelText: 'EXAMPLE',
              hintText: '예문을 입력해주세요',
            ),
            SizedBox(height: 70),
            ElevatedButton.icon(
              onPressed: _addWord,
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 60.0, //
              ),
              label: SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _wordDataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_wordDataList[index].word),
                    subtitle: Text(_wordDataList[index].meaning),
                    trailing: Icon(Icons.edit),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF121F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _addWord() {
    final wordText = _wordController.text;
    final meaningText = _meaningController.text;

    if (wordText.isEmpty || meaningText.isEmpty) {
      _showToast('필수 항목을 모두 입력해주세요');
      return;
    }

    final newWordData = WordData(
      word: wordText,
      meaning: meaningText,
      example: _exampleController.text,
    );

    setState(() {
      _wordDataList.add(newWordData);
      _wordController.clear();
      _meaningController.clear();
      _exampleController.clear();

      _showToast('저장에 성공했습니다');

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: 311,
          height: 13,
          decoration: BoxDecoration(
            color:
                Color.fromARGB(255, 51, 50, 50), // 토스트 배경색을 주변 버튼 색상과 일치하도록 설정
            borderRadius: BorderRadius.circular(
                8.0), // 토스트의 모서리를 둥글게 설정하려고 했는데 적용 안됨/ 아마 컨테이너에 적용해야할듯함
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero), // 토스트의 테두리 없음
      ),
    );
  }
}

class WordData {
  final String word;
  final String meaning;
  final String example;

  WordData({
    required this.word,
    required this.meaning,
    required this.example,
  });
}
