import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rifund/screens/affichage_communaut_page/affichage_communaut_page.dart';
import 'package:rifund/screens/affichage_communaut_page/provider/affichage_communaut_provider.dart';
import '../../theme/theme_helper.dart';
import 'provider/chat_box_provider.dart';

class ChatBoxScreen extends StatelessWidget {
  const ChatBoxScreen({
    super.key,
    required this.userId,
    required this.projectId,
    required this.communityId,
    required this.messageId,
  });

  final String userId;
  final String projectId;
  final String communityId;
  final String messageId;

  static Widget builder(
    BuildContext context, {
    required String userId,
    required String projectId,
    required String communityId,
  }) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = ChatBoxProvider();

        provider.setup(userId, projectId, communityId);
        return provider;
      },
      child: ChatBoxScreen(
        userId: userId,
        projectId: projectId,
        communityId: communityId,
        messageId: '',
      ),
    );
  }

  Future<void> updateMessage(String userId, String projectId,
      String communityId, String messageId, String newMessage) async {
    if (projectId.isEmpty || communityId.isEmpty || messageId.isEmpty) {
      log('One or more Firestore path parameters are empty.');
      throw Exception(
          'Project ID, Community ID, or Message ID cannot be empty.');
    }

    try {
      log('Attempting to update message at path: users/$userId/projects/$projectId/communities/$communityId/messages/$messageId');

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
        log('Document not found: $messageId');
        throw Exception('Document not found');
      }

      await docRef.update({'message': newMessage});
      log('Message updated successfully. $messageId');
    } catch (e) {
      log('Error updating message: $e');
      rethrow;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    if (messageId.isEmpty) {
      log("Message ID is empty. Cannot delete message.");
      return;
    }

    try {
      DocumentSnapshot messageDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId)
          .collection('chat_messages')
          .doc(messageId)
          .get();

      if (messageDoc.exists) {
        await messageDoc.reference.delete();
        log("Message deleted successfully");
      } else {
        log("Message not found, unable to delete.");
      }
    } catch (e) {
      log("Error deleting message: $e");
    }
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
            const SizedBox(height: 10),

            // Message list section
            Expanded(
              child: Consumer<ChatBoxProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(height: 25),
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
      return const SizedBox();
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
                    padding: const EdgeInsets.all(15.0),
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
            const SizedBox(height: 5),
            Text(
              senderName,
              style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 10),
              Text(
                provider.communityName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
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
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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

  void _showMessageOptions(
      BuildContext context,
      String userId,
      String projectId,
      String communityId,
      String messageId,
      String currentMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modifier le message'),
              onTap: () {
                Navigator.pop(context);
                _editMessage(context, userId, projectId, communityId, messageId,
                    currentMessage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Supprimer le message'),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteMessage(context, messageId);
              },
            ),
          ],
        );
      },
    );
  }

  void _editMessage(
    BuildContext context,
    String userId,
    String projectId,
    String communityId,
    String messageId,
    String currentMessage,
  ) {
    final editingController = TextEditingController(text: currentMessage);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Modifier le message"),
          content: TextField(
            controller: editingController,
            decoration: const InputDecoration(
              hintText: "Entrer un nouveau message",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final newMessage = editingController.text;

                Navigator.of(dialogContext).pop();

                try {
                  await updateMessage(
                      userId, projectId, communityId, messageId, newMessage);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Message mis à jour avec succès")),
                    );
                  }

                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Erreur lors de la mise à jour du message: $e")),
                    );
                  }
                }
              },
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    ).then((_) {});
  }

  void _confirmDeleteMessage(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await deleteMessage(messageId);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer Message'),
            ),
          ],
        );
      },
    );
  }
}
