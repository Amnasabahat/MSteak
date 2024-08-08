import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MessageBox extends StatefulWidget {
  final ValueChanged<String> onSendMessage;

  const MessageBox({
    required this.onSendMessage,
    super.key,
  });

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => setState(() => _isListening = val == 'listening'),
      onError: (val) => print('Error: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _controller.text = val.recognizedWords;
        }),
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: _controller,
      maxLines: 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        prefixIcon: IconButton(
          onPressed: _isListening ? _stopListening : _startListening,
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
        suffix: IconButton(
          onPressed: () {
            widget.onSendMessage(_controller.text);
            _controller.text = '';
          },
          icon: const Icon(Icons.send),
        ),
      ),
      onSubmitted: (value) {
        widget.onSendMessage(value);
        _controller.text = '';
      },
    ),
  );
}
