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

  const ChatBoxScreen({
    Key? key,
    required this.userId,
    required this.projectId,
    required this.communityId, required messageId,
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
        communityId: communityId, messageId: '',
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

  Widget _buildMessage(BuildContext context, String message, {
    required bool isReceived,
    required String avatar,
    required String messageId,
    required String senderName,
  }) {
    if (message.isEmpty) {
      return SizedBox();
    }

    return GestureDetector(
      onLongPress: () => _showMessageOptions(context, messageId, message),
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
                      style: TextStyle(color: isReceived ? Colors.black : Colors.white),
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
          create: (_) => AffichageCommunautProvider(provider.userId,provider.projectId, provider.communityId),
          child: AffichageCommunautPage(userId:provider.userId,projectId:provider.projectId, communityId: provider.communityId,),
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

  void _showMessageOptions(BuildContext context, String messageId, String currentMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Message'),
              onTap: () {
                // Implement message editing logic
                _editMessage(context, messageId, currentMessage);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Message'),
              onTap: () {
                context.read<ChatBoxProvider>().deleteMessage(messageId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _editMessage(BuildContext context, String messageId, String currentMessage) {
    TextEditingController editingController = TextEditingController(text: currentMessage);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Message'),
          content: TextField(
            controller: editingController,
            decoration: InputDecoration(hintText: "Edit your message"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newMessage = editingController.text.trim();
                if (newMessage.isNotEmpty) {
                  context.read<ChatBoxProvider>().updateMessage(messageId, newMessage);
                  Navigator.pop(context);
                } else {
                  // Show a message or error if the new message is empty
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
