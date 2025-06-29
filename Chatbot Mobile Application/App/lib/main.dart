import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class ChatSession {
  String title;
  DateTime createdAt;
  List<String> messages;

  ChatSession({required this.title, required this.createdAt, required this.messages});

  Map<String, dynamic> toJson() => {
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages,
      };

  static ChatSession fromJson(Map<String, dynamic> json) => ChatSession(
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        messages: List<String>.from(json['messages']),
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
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
  List<ChatSession> sessions = [];
  int currentSessionIndex = 0;
  bool isThinking = false;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    loadSessions();
  }

  Future<void> loadSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedSessions = prefs.getStringList('chat_sessions');
    if (savedSessions != null) {
      setState(() {
        sessions = savedSessions.map((e) => ChatSession.fromJson(jsonDecode(e))).toList();
      });
    }
    if (sessions.isEmpty) {
      newChat();
    }
  }

  Future<void> saveSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> sessionStrings = sessions.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('chat_sessions', sessionStrings);
  }

  void newChat() {
    setState(() {
      final session = ChatSession(
        title: 'Chat ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
        createdAt: DateTime.now(),
        messages: [],
      );
      sessions.add(session);
      currentSessionIndex = sessions.length - 1;
    });
    saveSessions();
  }

  Future<String> getGroqResponse(String message) async {
    final apiKey = "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";
    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: json.encode({
        "model": "llama3-8b-8192",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": message}
        ],
        "temperature": 0.7
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.statusCode} - ${response.body}";
    }
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      sessions[currentSessionIndex].messages.add("You: $text");
      sessions[currentSessionIndex].messages.add("Bot: thinking...");
      _controller.clear();
      isThinking = true;
    });
    await saveSessions();

    final response = await getGroqResponse(text);

    setState(() {
      sessions[currentSessionIndex].messages.removeLast();
      sessions[currentSessionIndex].messages.add("Bot: $response");
      isThinking = false;
    });
    await saveSessions();
  }

  @override
  Widget build(BuildContext context) {
    final currentMessages = sessions.isNotEmpty ? sessions[currentSessionIndex].messages : [];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('AI Chatbot'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('New Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                leading: Icon(Icons.add),
                onTap: () {
                  newChat();
                  Navigator.pop(context);
                },
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        sessions[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tileColor: index == currentSessionIndex ? Colors.blue[100] : null,
                      onTap: () {
                        setState(() {
                          currentSessionIndex = index;
                        });
                        Navigator.pop(context);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            sessions.removeAt(index);
                            if (sessions.isEmpty) {
                              newChat();
                            } else if (currentSessionIndex >= sessions.length) {
                              currentSessionIndex = sessions.length - 1;
                            }
                          });
                          saveSessions();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: currentMessages.length,
                    itemBuilder: (context, index) {
                      String message = currentMessages[index];
                      bool isUser = message.startsWith("You:");
                      bool isBot = message.startsWith("Bot:");

                      return ListTile(
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: isUser
                                    ? "You:"
                                    : isBot
                                        ? "Bot:"
                                        : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isUser
                                      ? Colors.blue
                                      : isBot
                                          ? Colors.green
                                          : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: message.contains(":")
                                    ? message.substring(message.indexOf(":") + 1)
                                    : message,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
          ),
        ],
      ),
    );
  }
}
