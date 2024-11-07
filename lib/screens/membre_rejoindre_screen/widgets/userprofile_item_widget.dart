import 'package:flutter/material.dart';
import '../models/userprofile_item_model.dart';
import '../provider/membre_rejoindre_provider.dart';

class UserprofileItemWidget extends StatelessWidget {
  final UserprofileItemModel model;
  final MembreRejoindreProvider provider;
  final String communityId;
  final String userId;
  final String projectId;

  UserprofileItemWidget({
    required this.model,
    required this.provider,
    required this.communityId,
    required this.userId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(model.userImage ?? ''),
        ),
        title: Text(model.username ?? 'Unknown'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.heart_broken_outlined, color: Colors.green),
              onPressed: () => provider.approveMember(
                model.id ?? '',
                communityId,
                userId,  // Pass userId to approveMember
                projectId,  // Pass projectId to approveMember
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => provider.rejectMember(
                model.id ?? '',
                communityId,
                userId,  // Pass userId to rejectMember
                projectId,  // Pass projectId to rejectMember
              ),
            ),
          ],
        ),
      ),
    );
  }
}
