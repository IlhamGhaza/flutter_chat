import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/features/chat/presentation/pages/chat_page.dart';

import '../bloc/contact_bloc.dart';
import 'contact_details_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch contacts when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactBloc>().add(FetchContactEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: BlocListener<ContactBloc, ContactState>(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ContactLoaded) {
              return state.contacts.isEmpty
                  ? _buildEmptyContacts()
                  : _buildContactsList(state);
            } else if (state is ContactError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ContactBloc>().add(FetchContactEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return _buildEmptyContacts();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyContacts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No contacts found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add new contacts to start chatting',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddContactDialog(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Add Contact'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(ContactLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.contacts.length,
      itemBuilder: (context, index) {
        final contact = state.contacts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailsPage(
                    contact: contact,
                  ),
                ),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Hero(
              tag: 'contact_${contact.id}',
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(contact.photoProfile),
                onBackgroundImageError: (_, __) {},
                child: contact.photoProfile.isEmpty
                    ? Text(
                        contact.username[0],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
            title: Text(
              contact.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                contact.email,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.message, color: Colors.blue),
              onPressed: () {
                BlocProvider.of<ContactBloc>(context).add(
                    CheckOrCreateConversationEvent(contact, contact.username));
              },
            ),
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Contacts'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Enter name or email',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement search functionality
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final TextEditingController findUserController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: findUserController,
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Enter username or email',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter a username or email address to find and add a contact.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final findUser = findUserController.text.trim();
                if (findUser.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a username or email'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  if (findUser.contains('@')) {
                    context.read<ContactBloc>().add(
                          AddContactEvent(username: null, email: findUser),
                        );
                  } else {
                    context.read<ContactBloc>().add(
                          AddContactEvent(username: findUser, email: null),
                        );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Searching for $findUser...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
