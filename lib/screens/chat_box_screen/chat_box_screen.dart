import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/screens/affichage_communaut_page/affichage_communaut_page.dart';
import 'package:rifund/screens/affichage_communaut_page/provider/affichage_communaut_provider.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import 'provider/chat_box_provider.dart';

class ChatBoxScreen extends StatelessWidget {
  final String userId;
  final String projectId;
  final String communityId;
Future<void> updateMessage(String userId, String projectId, String communityId, String messageId, String newMessage) async {
  if (projectId.isEmpty || communityId.isEmpty || messageId.isEmpty) {
    print('One or more Firestore path parameters are empty.');
    throw Exception('Project ID, Community ID, or Message ID cannot be empty.');
  }

  try {
    print('Attempting to update message at path: users/$userId/projects/$projectId/communities/$communityId/messages/$messageId');

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('chat_messages')
        .doc(messageId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      print('Document not found: $messageId');
      throw Exception('Document not found'); // Optionally throw or handle as needed
    }

    await docRef.update({'message': newMessage});
    print('Message updated successfully. $messageId');
  } catch (e) {
    print('Error updating message: $e');
    throw e; // Re-throw or handle error as needed
  }
}

  const ChatBoxScreen({
    Key? key,
    required this.userId,
    required this.projectId,
    required this.communityId,
    required messageId,
  }) : super(key: key);

  static Widget builder(
    BuildContext context, {
    required String userId,
    required String projectId,
    required String communityId,
  }) {
    return ChangeNotifierProvider(
      create: (context) => ChatBoxProvider(projectId, communityId),
      child: ChatBoxScreen(
        userId: userId,
        projectId: projectId,
        communityId: communityId,
        messageId: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.orange50,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Header section
            Consumer<ChatBoxProvider>(
              builder: (context, provider, _) {
                return _buildHeader(context, provider);
              },
            ),
            SizedBox(height: 10),

            // Message list section
            Expanded(
              child: Consumer<ChatBoxProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      Message message = provider.messages[index];
                      return _buildMessage(
                        context,
                        message.message,
                        isReceived: message.isReceived,
                        avatar: message.userImage.isNotEmpty
                            ? message.userImage
                            : 'assets/images/avatar.png', // Default avatar
                        messageId: message.id,
                        senderName: message.userName,
                      );
                    },
                  );
                },
              ),
            ),

            // Input field for sending messages
            _buildInputField(context),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context,
    String message, {
    required bool isReceived,
    required String avatar,
    required String messageId,
    required String senderName,
  }) {
    if (message.isEmpty) {
      return SizedBox();
    }

    return GestureDetector(
      onLongPress: () => _showMessageOptions(
          context, userId, projectId, communityId, messageId, message),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment:
              isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isReceived)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: isReceived ? Colors.black : Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: isReceived ? Colors.black : Colors.white),
                    ),
                  ),
                ),
                if (!isReceived)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              senderName,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ChatBoxProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 10),
              Text(
                provider.communityName,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Navigate to community details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => AffichageCommunautProvider(provider.userId,
                        provider.projectId, provider.communityId),
                    child: AffichageCommunautPage(
                      userId: provider.userId,
                      projectId: provider.projectId,
                      communityId: provider.communityId,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Consumer<ChatBoxProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.messageController,
                  decoration: InputDecoration(
                    hintText: 'créer un message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                onPressed: () {
                  provider.sendMessage(provider.messageController.text.trim());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessageOptions(BuildContext context, String userId, String projectId, String communityId, String messageId, String currentMessage) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Modifier le message'),
            onTap: () {
              Navigator.pop(context); // Fermer la feuille de fond avant d'afficher le dialog
              _editMessage(context, userId, projectId, communityId, messageId, currentMessage);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supprimer le message'),
            onTap: () {
              Navigator.pop(context); // Fermer la feuille de fond
              _confirmDeleteMessage(context, userId, projectId, communityId, messageId);
            },
          ),
        ],
      );
    },
  );
}

void _editMessage(
  BuildContext scaffoldContext,
  String userId,
  String projectId,
  String communityId,
  String messageId,
  String currentMessage,
) {
  final editingController = TextEditingController(text: currentMessage);

  showDialog(
    context: scaffoldContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text("Modifier le message"),
        content: TextField(
          controller: editingController,
          decoration: InputDecoration(
            hintText: "Entrer un nouveau message",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
            },
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              // Store the new message in a variable to avoid accessing the controller after dialog closure
              final newMessage = editingController.text;

              Navigator.of(dialogContext).pop(); // Close dialog immediately

              // Perform the update operation outside the dialog context
              try {
                await updateMessage(userId, projectId, communityId, messageId, newMessage);

                // Ensure the ScaffoldMessenger context is still valid
                if (scaffoldContext.mounted) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text("Message mis à jour avec succès")),
                  );
                }
              } catch (e) {
                if (scaffoldContext.mounted) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text("Erreur lors de la mise à jour du message: $e")),
                  );
                }
              }
            },
            child: Text("Confirmer"),
          ),
        ],
      );
    },
  ).then((_) {
    // Dispose of the controller after dialog closure to prevent use-after-disposal
    if (!editingController.hasListeners) {
      editingController.dispose();
    }
  });
}




  void _confirmDeleteMessage(BuildContext context, String userId,
      String projectId, String communityId, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Call the delete function from your provider
                context
                    .read<ChatBoxProvider>()
                    .deleteMessage(userId, projectId, communityId, messageId);
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context)
                    .pop(); // Close the bottom sheet if it was open
              },
              child: Text('supprimer Message '),
            ),
          ],
        );
      },
    );
  }
}
