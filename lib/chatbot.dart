import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hi! What would you like to do today?"},
    {
      "sender": "bot",
      "text": "I can suggest attractions, restaurants, or events!"
    },
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message to the list
    setState(() {
      _messages.add({"sender": "user", "text": text});
      _messageController.clear();
    });

    // Simulate a bot response after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          "sender": "bot",
          "text": _generateBotResponse(text),
        });
      });
    });
  }

  String _generateBotResponse(String userMessage) {
    // Simulate AI-based recommendations
    if (userMessage.toLowerCase().contains("breakfast")) {
      return "Try 'Warung Kopi Bukit' for a great breakfast nearby!";
    } else if (userMessage.toLowerCase().contains("festival")) {
      return "The Medan Cultural Festival is happening today at Lapangan Merdeka!";
    } else if (userMessage.toLowerCase().contains("attraction")) {
      return "Visit the iconic Istana Maimun for a dose of history!";
    } else {
      return "I'm not sure about that, but you can explore attractions, restaurants, or events.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Ask MedanGo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat messages display
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal[100] : Colors.orange[100],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                        bottomRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      message["text"] ?? "",
                      style: TextStyle(
                        color: isUser ? Colors.black87 : Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Text input field for user messages
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
