import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/bloc/theme_cubit.dart';
import '../core/theme.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Messages',
              style: theme.textTheme.titleLarge,
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: theme.iconTheme.color),
              ),
            ],
          ),
          body: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Recent Contacts',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Container(
                height: 100,
                padding: EdgeInsets.all(5),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecentContact('John Doe', context, theme),
                    _buildRecentContact('Jane Doe', context, theme),
                    _buildRecentContact('John Doe', context, theme),
                    _buildRecentContact('Jane Doe', context, theme),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? DefaultColors.messageListPage
                        : Colors.white, // Putih untuk light mode
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: isDarkMode
                        ? [] // Tanpa shadow di dark theme
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0,
                                  -2), // Memberikan efek seperti "mengangkat"
                            ),
                          ], // Memberikan shadow lembut di light mode
                  ),
                  child: ListView(
                    children: [
                      _buildMessageTile(
                          'John Doe', 'Hello', '12:00 PM', context, theme),
                      _buildMessageTile(
                          'Jane Doe', 'Hi', '12:00 PM', context, theme),
                      _buildMessageTile(
                          'John Doe', 'Hello', '12:00 PM', context, theme),
                      _buildMessageTile(
                          'Jane Doe', 'Hi', '12:00 PM', context, theme),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentContact(
      String name, BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://picsum.photos/200'),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String name, String message, String time,
      BuildContext context, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('https://picsum.photos/200'),
      ),
      title: Text(
        name,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        message,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Text(
        time,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
