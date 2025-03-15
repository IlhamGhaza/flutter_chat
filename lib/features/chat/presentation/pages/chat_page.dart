import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/bloc/theme_cubit.dart';
import '../../../../core/theme.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String mate;
  const ChatPage({super.key, required this.conversationId, required this.mate});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(
      LoadMessageEvent(conversationId: widget.conversationId),
    );
    fetchUserId();
  }

  fetchUserId() async {
    String userid = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = userid;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text;
    if (content.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(
        SendMessageEvent(
            conversationId: widget.conversationId, content: content),
      );
      _messageController.clear();
    }
  }

  //file picker
  Future<void> _pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      final file = File(pickedFile.files.single.path!);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      BlocProvider.of<ChatBloc>(context).add(
        SendMessageEvent(
          conversationId: widget.conversationId,
          content: base64String,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.mate}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      'Online',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              //search
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {},
                tooltip: 'Search',
              ),
              IconButton(
                icon: Icon(
                  Icons.video_call,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {},
                tooltip: 'Video Call',
              ),
              IconButton(
                icon: Icon(
                  Icons.call,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {},
                tooltip: 'Call',
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {},
                tooltip: 'More',
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ChatLoadedState) {
                      final messages = state.messages;
                      return ListView.builder(
                        padding: const EdgeInsets.all(20.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          if (message.senderId == userId) {
                            return _buildSentMessage(
                                context, message.content.toString());
                          } else {
                            return _buildReceicedMessage(
                                context, message.content.toString());
                          }
                        },
                      );
                    } else if (state is ChatErrorState) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                    // return ListView(
                    //   padding: const EdgeInsets.all(20),
                    //   children: [
                    //     _buildReceicedMessage(context, 'Hello'),
                    //     _buildSentMessage(context, 'Hi'),
                    //   ],
                    // );
                  },
                ),
              ),
              _buildMessageInput(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceicedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 30, top: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.receiverMessage,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 30, top: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.senderMessage,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  //message input
  Widget _buildMessageInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: DefaultColors.senderMessage,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        spacing: 10,
        children: [
          GestureDetector(
            child: Icon(
              Icons.attach_file,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              //file picker
              _pickFile();
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.send,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: _sendMessage,
          ),
        ],
      ),
    );
  }
}
