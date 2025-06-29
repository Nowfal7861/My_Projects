import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

        void main() {
        runApp(MyApp());
        }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'AI Chatbot',
            theme: ThemeData(primarySwatch: Colors.blue),
    home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool isThinking = false;

  Future<String> getGroqResponse(String message) async {
    final apiKey = "<PLACE YOUR GROQ API KEY>"; // Groq API Key
    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final response = await http.post(
            url,
            headers: {
      "Content-Type": "application/json",
              "Authorization": "Bearer $apiKey",
    },
    body: json.encode({
            "model": "llama-3.1-8b-instant",  // Groq's supported model
            "messages": [
    {"role": "user", "content": message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.statusCode}";
    }
  }

  void sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add("You: $text");
      messages.add("Bot: thinking...");
      _controller.clear();
      isThinking = true;
    });

    final response = await getGroqResponse(text);

    setState(() {
      messages.removeLast(); // Remove "thinking..."
      messages.add("Bot: $response");
      isThinking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: Text('AI Chatbot')),
    body: Column(
            children: [
    Expanded(
            child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) => ListTile(
            title: Text(messages[index]),
              ),
            ),
          ),
    Divider(height: 1.0),
    Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
            children: [
    Expanded(
            child: TextField(
            controller: _controller,
            onSubmitted: (_) => sendMessage(),
            decoration: InputDecoration(hintText: "Type your message..."),
                  ),
                ),
    IconButton(
            icon: Icon(Icons.send),
            onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
