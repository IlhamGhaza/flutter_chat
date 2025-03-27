import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/bloc/theme_cubit.dart';
import '../../../../core/constant.dart';
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
    super.initState();
    fetchUserId();
    BlocProvider.of<ChatBloc>(context).add(
      LoadMessageEvent(conversationId: widget.conversationId),
    );
  }

  Future<void> fetchUserId() async {
    String fetchedUserId = await _storage.read(key: StorageKeys.userId) ?? '';
    setState(() {
      userId = fetchedUserId;
    });
    log('Fetched userId: $userId');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.primaryColor,
                  backgroundImage:
                      widget.mate.length > 1 ? NetworkImage(widget.mate) : null,
                  child: widget.mate.length == 1
                      ? Text(
                          widget.mate.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Online',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: theme.iconTheme.color),
                onPressed: () {},
                tooltip: 'Search',
              ),
              IconButton(
                icon: Icon(Icons.video_call, color: theme.iconTheme.color),
                onPressed: () {},
                tooltip: 'Video Call',
              ),
              IconButton(
                icon: Icon(Icons.call, color: theme.iconTheme.color),
                onPressed: () {},
                tooltip: 'Call',
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
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
                    if (state is ChatLoadedState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            bool isSentByMe = message.senderId.toString() == userId;
                            log('Message senderId: ${message.senderId}, userId: $userId, isSentByMe: $isSentByMe'); // Debugging
                            if (isSentByMe) {
                              return _buildSentMessage(context, message.content.toString(), theme);
                            } else {
                              return _buildReceicedMessage(context, message.content.toString(), theme);
                            }
                          },
                        ),
                      );
                    } else if (state is ChatLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ChatErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              _buildMessageInput(context, theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceicedMessage(BuildContext context, String message, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 30, top: 5, left: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? DefaultColors.darkReceiverMessage
              : DefaultColors.lightReceiverMessage,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message, ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 30, top: 5, right: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? DefaultColors.darkSenderMessage
              : DefaultColors.lightSenderMessage,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? DefaultColors.darkInputBackground
            : DefaultColors.lightInputBackground,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.attach_file,
              color: theme.iconTheme.color,
            ),
                        onTap: _pickFile,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: theme.hintColor),
                border: InputBorder.none,
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            child: Icon(
              Icons.send,
              color: theme.iconTheme.color,
            ),
            onTap: _sendMessage,
          ),
        ],
      ),
    );
  }
}
