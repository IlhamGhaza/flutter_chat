import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:flutter_chat/features/contact/presentation/pages/contact_page.dart';
import 'package:flutter_chat/features/conversation/presentation/bloc/conversation_bloc.dart';

import '../../../../core/bloc/theme_cubit.dart';
import '../../../../core/theme.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
    // Add this line to fetch contacts when the page loads
    BlocProvider.of<ContactBloc>(context).add(FetchContactEvent());
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Recent',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              // Add BlocBuilder for ContactBloc to display recent contacts
              Container(
                height: 100,
                padding: EdgeInsets.all(5),
                child: BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    if (state is ContactLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ContactError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is ContactLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.contacts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // When a contact is tapped, create or check for a conversation
                              context.read<ContactBloc>().add(
                                    CheckOrCreateConversationEvent(
                                      contactId: state.contacts[index],
                                      contactName:
                                          state.contacts[index].username,
                                    ),
                                  );
                            },
                            child: _buildRecentContact(
                              state.contacts[index].username,
                              state.contacts[index].photoProfile ??
                                  'https://via.placeholder.com/150',
                              context,
                              theme,
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: Text('No contacts found'));
                  },
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? DefaultColors.messageListPage
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: isDarkMode
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, -2),
                            ),
                          ],
                  ),
                  child: BlocBuilder<ConversationBloc, ConversationState>(
                    builder: (context, state) {
                      if (state is ConversationLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ConversationError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      } else if (state is ConversationLoaded) {
                        return ListView.builder(
                          itemCount: state.conversations.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      conversationId: state
                                          .conversations[index].id
                                          .toString(),
                                      mate: state
                                          .conversations[index].participantName,
                                    ),
                                  ),
                                );
                              },
                              child: _buildMessageTile(
                                state.conversations[index].participantName,
                                state.conversations[index].lastMessage,
                                state.conversations[index].participantPhoto,
                                state.conversations[index].lastMessageTime,
                                context,
                                theme,
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: Text('No conversations found.'),
                      );
                    },
                  ),
                ),
              ),

              // Add BlocListener to handle conversation creation
              BlocListener<ContactBloc, ContactState>(
                listener: (context, state) {
                  if (state is ConversationCreated) {
                    // Navigate to chat page when conversation is created
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          conversationId: state.conversationId,
                          mate: state.contactName,
                        ),
                      ),
                    );
                  }
                },
                child:
                    Container(), // Empty container as we only need the listener
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: isDarkMode ? Colors.black : Colors.white,
            tooltip: 'add message',
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(),
                ),
              );
            },
            child: const Icon(Icons.message),
          ),
        );
      },
    );
  }

  Widget _buildRecentContact(
      String name, String photo, BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.primaryColor,
            backgroundImage: photo.length > 1 ? NetworkImage(photo) : null,
            child: photo.length == 1
                ? Text(
                    photo.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : null,
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

  Widget _buildMessageTile(String name, String message, String photo,
      DateTime time, BuildContext context, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: theme.primaryColor,
        backgroundImage: photo.length > 1 ? NetworkImage(photo) : null,
        child: photo.length == 1
            ? Text(
                photo.toUpperCase(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : null,
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
        time.toString(),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
