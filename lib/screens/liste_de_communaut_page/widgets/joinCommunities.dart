import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../../membre_rejoindre_screen/membre_rejoindre_screen.dart';
import '../models/CommunityjoincardsectionItemModel.dart';
import '../models/communitycardsection_item_model.dart';
import '../provider/liste_de_communaut_provider.dart';

class JoinCommunityCardItemWidget extends StatelessWidget {
  final CommunityjoincardsectionItemModel model;
  final String userId;
  final String communityId; // Add this line to define communityId

  const JoinCommunityCardItemWidget({
    Key? key,
    required this.model,
    required this.userId,
    required this.communityId, // Ensure communityId is part of the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.h, vertical: 3.v),
      decoration: AppDecoration.outlineWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommunityImage(),
          Expanded(child: _buildCommunityDetails(context)),
        ],
      ),
    );
  }

  Widget _buildCommunityImage() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: ClipOval(
        child: model.imageUrl.isNotEmpty
            ? Image.network(
                model.imageUrl,
                height: 58.adaptSize,
                width: 58.adaptSize,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_image.png',
                    height: 58.adaptSize,
                    width: 58.adaptSize,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'assets/images/default_image.png',
                height: 58.adaptSize,
                width: 58.adaptSize,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildCommunityDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17.h, top: 1.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.v),
          _buildDetailRow(
              "Nom de la communauté:", model.name, theme.textTheme.titleLarge),
          SizedBox(height: 12.v),
          _buildDetailRow(
              "Description:", model.description, theme.textTheme.bodyMedium,
              maxLines: 2),
          SizedBox(height: 12.v),
          _buildJoinButton(context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String content, TextStyle? style,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Text(
          content,
          style: style,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ],
    );
  }

Widget _buildJoinButton(BuildContext context) {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  return Row(
     mainAxisAlignment: MainAxisAlignment.center, // This will center the icon horizontally
    children: [
      IconButton(
        icon: const Icon(Icons.message),
        onPressed: () async {
          try {
            print(
                'Fetching messages for community ${model.communityId} in project ${model.projectId}');

            // Fetch chat messages from Firestore
            final messagesQuery = FirebaseFirestore.instance
                .collection('users')
                .doc(model.userId)
                .collection('projects')
                .doc(model.projectId)
                .collection('communities')
                .doc(model.communityId)
                .collection('chat_messages');

          final messagesSnapshot = await messagesQuery.get();

// Debug: Check the number of documents
print('Messages found: ${messagesSnapshot.docs.length}');

// If no messages are found, create an empty list or handle it accordingly
final messages = messagesSnapshot.docs.isEmpty
    ? []  // Return an empty list if no messages
    : messagesSnapshot.docs.map((doc) {
        // Include messageId in each message's data
        var messageData = doc.data();
        messageData['messageId'] = doc.id;  // Add messageId field to the data
        return messageData;
      }).toList();

// Now `messages` contains the message data along with the messageId for each message

              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBoxScreen.builder(
                          context,
                          userId: model.userId ?? '',
                          projectId: model.projectId ?? '',
                          communityId: model.communityId!,
                        ),
                      ),
                    );

          } catch (e) {
            // Handle errors (network issues, etc.)
            print('Error fetching messages: $e');
            
            // Optionally show an error message to the user
          }
        },
      ),
    ],
  );
}

}
