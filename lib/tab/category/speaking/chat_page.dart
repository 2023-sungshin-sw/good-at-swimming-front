import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:good_swimming/tab/category/speaking/speaking_page.dart'; // 추가된 부분
import 'package:speech_to_text/speech_to_text.dart' as stt; // 추가된 부분

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  stt.SpeechToText _speech = stt.SpeechToText(); // 음성 인식 객체 추가

  List<String> _messages = [];

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add('You: $message');
      _messageController.clear();
    });

    try {
      // Chat GPT API 호출 및 응답 처리
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
        headers: {
          'Authorization':
              'http://www.good-at-swimming-back.store/chat/reply/', // API 키 입력, 여기에 실제 Chat GPT API 키를 입력해야 함
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': message,
          'max_tokens': 50, // 챗봇 응답 토큰 수 조정
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data['choices'][0]['text'];
        setState(() {
          _messages.add('Bot: $botReply');
        });
      } else {
        print('Failed to get bot response');
      }
    } catch (e) {
      print('Error: $e');
    }

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // 마이크 버튼 클릭 시 처리
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
          });
        },
      );
    } else {
      print('The user has denied the use of speech recognition.');
    }
  }

  // 마이크 버튼 클릭 시 중지 처리
  void _stopListening() {
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SpeakingPage()),
            );
          },
        ),
        title: const Text(
          'TOPIC', // 메뉴에서 어떤 토픽을 선택하냐에 따라서 달라짐
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF121F33), // 배경색 설정
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: _messages[index].startsWith('You: ')
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: _messages[index].startsWith('You: ')
                              ? Color(0xFF5C65BB) // 내가 보내는 채팅 배경색
                              : const Color(0xFF121F33), // 챗봇의 채팅 배경색
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _messages[index],
                          style: TextStyle(
                            color: _messages[index].startsWith('You: ')
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.mic),
                onPressed: () {
                  // 마이크 버튼 클릭 시 처리
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message…',
                  ),
                  onFieldSubmitted: _sendMessage,
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _sendMessage(_messageController.text);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // 화살표 버튼 클릭 시 처리
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
