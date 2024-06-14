import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const TabBarExample(),
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: Image.asset('images/chatgpt.png'),
                ),
              ),
              Tab(
                icon: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: Image.asset('images/gemini.png'),
                ),
              ),
              Tab(
                icon: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: Image.asset('images/copilot.png'),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ChatScreenChatGPT(),
            ChatScreenGemini(),
            ChatScreenCopilot(),
          ],
        ),
      ),
    );
  }
}

class ChatScreenChatGPT extends StatefulWidget {
  const ChatScreenChatGPT({Key? key}) : super(key: key);

  @override
  _ChatScreenChatGPTState createState() => _ChatScreenChatGPTState();
}

class _ChatScreenChatGPTState extends State<ChatScreenChatGPT> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiKeyChatGPT = '';

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    var body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 150,
      'temperature': 0.7,
    });

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKeyChatGPT',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': jsonDecode(response.body)['choices'][0]['message']
                ['content']
          });
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': 'Error fetching response: ${response.reasonPhrase}'
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'Network error: $e'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Cor da borda
                width: 1.0, // Largura da borda
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                final textColor = isUser ? Colors.black : Colors.white;
                final backgroundColor =
                    isUser ? Colors.transparent : Colors.grey;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: Colors.grey, // Cor da borda
                        width: 1.0, // Largura da borda
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      message['content']!,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Faça seu pedido para o ChatGPT...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatScreenGemini extends StatefulWidget {
  const ChatScreenGemini({Key? key}) : super(key: key);

  @override
  _ChatScreenGeminiState createState() => _ChatScreenGeminiState();
}

class _ChatScreenGeminiState extends State<ChatScreenGemini> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiKeyGemini = '';

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    var body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 150,
      'temperature': 0.7,
    });

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKeyGemini',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': jsonDecode(response.body)['choices'][0]['message']
                ['content']
          });
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': 'Error fetching response: ${response.reasonPhrase}'
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'Network error: $e'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Cor da borda
                width: 1.0, // Largura da borda
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                final textColor = isUser ? Colors.black : Colors.white;
                final backgroundColor =
                    isUser ? Colors.transparent : Colors.grey;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: Colors.grey, // Cor da borda
                        width: 1.0, // Largura da borda
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      message['content']!,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Diga o que quiser ao Gemini...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatScreenCopilot extends StatefulWidget {
  const ChatScreenCopilot({Key? key}) : super(key: key);

  @override
  _ChatScreenCopilotState createState() => _ChatScreenCopilotState();
}

class _ChatScreenCopilotState extends State<ChatScreenCopilot> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiKeyCopilot = '';

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    var body = jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 150,
      'temperature': 0.7,
    });

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKeyCopilot',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': jsonDecode(response.body)['choices'][0]['message']
                ['content']
          });
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': 'Error fetching response: ${response.reasonPhrase}'
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'Network error: $e'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Cor da borda
                width: 1.0, // Largura da borda
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                final textColor = isUser ? Colors.black : Colors.white;
                final backgroundColor =
                    isUser ? Colors.transparent : Colors.grey;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: Colors.grey, // Cor da borda
                        width: 1.0, // Largura da borda
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      message['content']!,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Fale o que desejar para o Copilot...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
