import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chatshare/core/theme.dart';
import 'package:chatshare/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chatshare/features/chat/presentation/bloc/chat_event.dart';
import 'package:chatshare/features/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String mate;
  final String profileImage;

  const ChatPage({super.key, required this.conversationId, required this.mate, required this.profileImage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String userId = '';
  String botId = '00000000-0000-0000-0000-000000000000';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(LoadMessagesEvent(widget.conversationId));
    fetchUserId();
  }

  fetchUserId() async {
    userId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = userId;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if(content.isNotEmpty){
      BlocProvider.of<ChatBloc>(context).add(
          SendMessageEvent(widget.conversationId, content)
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImage),
            ),
            SizedBox(width: 10,),
            Text(
              // ignore: unnecessary_string_interpolations
              '${widget.mate}',
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.search)
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state){
                if(state is ChatLoadingState){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is ChatLoadedState){
                  return ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index){
                        final message = state.messages[index];
                        final isSentMessage = message.senderId == userId;
                        final isDailyQuestion = message.senderId == botId;

                        if(isSentMessage) {
                          return _buildSentMessage(context, message.content);
                        }
                        else if(isDailyQuestion){
                          return _buildDailyQuestionMessage(context, message.content);
                        }
                        else {
                          return _buildReceivedMessage(context, message.content);
                        }
                      },
                    );
                }
                else if(state is ChatErrorState) {
                  return Center(child: Text(state.message),);
                }
                return Center(child: Text('No messages found.'),);
              },
            ),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.receiverMessage,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(
            message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: DefaultColors.senderMessage,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildDailyQuestionMessage(BuildContext context, String message){
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: DefaultColors.dailyQuestionColor,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Text(
          "🧠 Daily Question : $message",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildMessageInput(){
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(25)
      ),
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey,
            ),
            onTap: (){},
          ),
          SizedBox(width: 10,),
          Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none
                ),
                style: TextStyle(color: Colors.white),
              )
          ),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: _sendMessage,
            child: Icon(
              Icons.send,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

}
