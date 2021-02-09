import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chatMessage.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Bubble(
            message: text,
            time: '12:00',
            delivered: true,
            isMe: false,
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enviar un mensaje"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)),
              ),
            ]
        )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mensaje")),
      body: GestureDetector(
        //onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        onHorizontalDragDown: (_){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  )
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ]
        ),
      ),
    );
  }
}
