import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/bloc/theme_cubit.dart';
import '../core/theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
                      'Dany',
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
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildReceicedMessage(context, 'Hello'),
                    _buildSentMessage(context, 'Hi'),
                  ],
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
            onTap: () {},
          ),
          Expanded(
            child: TextField(
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
