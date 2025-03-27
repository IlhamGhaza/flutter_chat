import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/theme_cubit.dart';
import '../../../../core/theme.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '/features/contact/domain/entities/contact_entity.dart';
import '../bloc/contact_bloc.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactEntity contact;

  const ContactDetailsPage({super.key, required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

        return BlocListener<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ConversationCreated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    conversationId: state.conversationId,
                    mate: state.contactName,
                  ),
                ),
              );
            } else if (state is ContactError) {
              log('Error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red, // Ubah warna snackbar di sini
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text('Contact Details', style: theme.textTheme.titleLarge),
              backgroundColor: theme.primaryColor,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, color: theme.iconTheme.color),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'contact_${widget.contact.id}',
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: theme.colorScheme.secondary,
                          backgroundImage:
                              widget.contact.photoProfile.length > 1
                                  ? NetworkImage(widget.contact.photoProfile)
                                  : null,
                          child: widget.contact.photoProfile.length == 1
                              ? Text(
                                  widget.contact.photoProfile.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: theme.colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          widget.contact.username,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.contact.email,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildInfoCard('Status', 'Online', theme),
                        SizedBox(height: 40),
                        ElevatedButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text('Start Chat'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSecondary,
                            backgroundColor: theme.colorScheme.secondary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => _navigateToChat(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text(
              'Are you sure you want to delete this contact? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete contact
                BlocProvider.of<ContactBloc>(context).add(
                  DeleteContactEvent(
                    id: widget.contact.id.toString(),
                  ),
                );
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to contacts list
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChat(BuildContext context) {
    context.read<ContactBloc>().add(
          CheckOrCreateConversationEvent(
            contactId: widget.contact,
            contactName: widget.contact.username,
          ),
        );
  }
}
