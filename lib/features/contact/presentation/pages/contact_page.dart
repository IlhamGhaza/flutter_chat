import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contact_bloc.dart';
import 'contact_details_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ContactLoaded) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ListView.builder(
                  itemCount: state.contacts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactDetailsPage(
                              contact: state.contacts[index],
                            ),
                          ),
                        );
                      },

                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(state.contacts[index].photoProfile),
                      ),
                      title: Text(state.contacts[index].username),
                      subtitle: Text(state.contacts[index].email),
                    );
                  },
                ),
              );
            } else if (state is ContactError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('No contacts found'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContactDialog(context),
          child: const Icon(Icons.add),
        ));
  }

  void _showAddContactDialog(BuildContext context) {
    //email or username
    String findUser = TextEditingController().text;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: findUser),
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
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
                final findUser = TextEditingController().text;
                if (findUser.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a username or email'),
                    ),
                  );
                } else if (findUser.contains('@')) {
                  BlocProvider.of<ContactBloc>(context)
                      .add(AddContactEvent(username: null, email: findUser));
                } else {
                  BlocProvider.of<ContactBloc>(context)
                      .add(AddContactEvent(username: findUser, email: null));
                }
                // onPressed: () {
                //   Navigator.pop(context);
                //   BlocProvider.of<ContactBloc>(context)
                //       .add(AddContactEvent(username: findUser, email: findUser));
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
