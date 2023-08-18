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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText(); // 음성 인식 객체 추가

  int? _roomId; // 토픽의 id?
  List<String> _questions = []; // 가져온 질문 목록
  int _currentQuestionIndex = 0; // 현재 보여지는 질문의 인덱스

  @override
  void initState() {
    super.initState();

    _startChat();
  }

  final List<String> _messages = [];

  Future<void> _startChat() async {
    _questions = [];
    try {
      final response = await http.get(
        Uri.parse(
            'http://www.good-at-swimming-back.store/chat/start/theater/1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _roomId = data['chat_room_id'];
        _questions = List<String>.from(data['question']);
        print(_questions);

        setState(() {
          _messageController.text = 'Bot: ${_questions[0]}';
        });
      } else {
        print('Failed to start chat');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // 사용자 응답 처리
  void _handleUserResponse(String userResponse) async {
    // 사용자 응답을 추가
    setState(() {
      _messages.add('You: $userResponse');
    });

    try {
      // 채팅 post API 호출
      await http.post(
        Uri.parse('http://www.good-at-swimming-back.store/chat/reply/'),
        body: {
          'chat_room': _roomId, // chat_room 값을 사용자마다 다르게 설정
          'message': userResponse, // 사용자 입력 텍스트를 전달
        },
      );
    } catch (e) {
      print('Error: $e');
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      setState(() {
        _messageController.text = 'Bot: ${_questions[_currentQuestionIndex]}';
      });
    } else {
      setState(() {
        _messageController.clear();
        _messages
            .add('Bot: That was the last question. Thank you for chatting!');
      });
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
                  decoration: const InputDecoration(
                    hintText: 'Type a message…',
                  ),
                  onFieldSubmitted: _handleUserResponse,
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _handleUserResponse(_messageController.text);
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
