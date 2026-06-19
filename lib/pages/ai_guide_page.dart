import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIGuidePage extends StatefulWidget {
  final String monumentName;

  const AIGuidePage({super.key, required this.monumentName});

  @override
  State<AIGuidePage> createState() => _AIGuidePageState();
}

class _AIGuidePageState extends State<AIGuidePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // TODO: Replace with your actual Gemini API Key from Google AI Studio
  static const String apiKey = 'YOUR_API_KEY_HERE';
  
  late final GenerativeModel _model;
  late final ChatSession _chat;
  
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize the Gemini model
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system('You are a friendly and extremely knowledgeable historical tour guide for ${widget.monumentName}. Answer questions about this monument, its history, architecture, and significance. Keep answers engaging and concise.'),
    );
    
    _chat = _model.startChat();
    
    // Add initial greeting
    _messages.add({
      'role': 'model',
      'text': 'Welcome to ${widget.monumentName}! I am your AI tour guide. What would you like to know about this wonderful monument?',
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    
    _controller.clear();
    _scrollToBottom();

    if (apiKey == 'YOUR_API_KEY_HERE') {
      // Simulate response if no API key is provided
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _messages.add({
          'role': 'model',
          'text': 'Please insert your Gemini API Key in `lib/pages/ai_guide_page.dart` to enable real AI responses.',
        });
        _isLoading = false;
      });
      _scrollToBottom();
      return;
    }

    try {
      final response = await _chat.sendMessage(Content.text(text));
      setState(() {
        _messages.add({'role': 'model', 'text': response.text ?? 'I have no answer for that.'});
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({'role': 'model', 'text': 'Oops! Something went wrong: $e'});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.monumentName} Guide'),
        backgroundColor: const Color(0xff6351ec),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return _buildMessageBubble(message['text'], isUser);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec)),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xff6351ec) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask about the monument...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xff6351ec),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
