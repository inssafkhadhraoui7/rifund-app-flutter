import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/widgets/custom_text_form_field.dart';
import '../../../core/app_export.dart';
import '../../membre_rejoindre_screen/membre_rejoindre_screen.dart';
import '../models/communitycardsection_item_model.dart';
import '../provider/liste_de_communaut_provider.dart';

class CommunitycardsectionItemWidget extends StatelessWidget {
  final CommunitycardsectionItemModel model;
  final String userId; // Assuming you need userId for ChatBoxScreen

  const CommunitycardsectionItemWidget({
    Key? key,
    required this.model,
    required this.userId,
    required communityId,
    required String projectId, // Accept userId
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
        child: Image.network(
          model.imageUrl.isNotEmpty
              ? model.imageUrl
              : '',
          height: 58.adaptSize,
          width: 58.adaptSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              '',
              height: 58.adaptSize,
              width: 58.adaptSize,
              fit: BoxFit.cover,
            );
          },
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
          _buildDetailRow(
              "Nom du projet:", model.projectName, theme.textTheme.titleLarge),
          SizedBox(height: 4.v),
          _buildDetailRow(
              "Nom de la communauté:", model.name, theme.textTheme.titleLarge),
          SizedBox(height: 12.v),
          _buildDetailRow(
              "Description:", model.description, theme.textTheme.bodyMedium,
              maxLines: 2),
          SizedBox(height: 12.v),
          _buildActionButtons(context),
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

  Widget _buildActionButtons(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _showEditDialog(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.group_add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MembreRejoindreScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatBoxScreen.builder(
                  context,
                  userId: currentUserId,
                  projectId: model.projectId, // Using model.projectId
                  communityId: model.communityId, // Using model.communityId
                ),
              ),
            );
          },
        ),
    IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () async {
    final provider = Provider.of<ListeDeCommunautProvider>(context, listen: false);
    
    // Show a confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer la communauté"),
          content: const Text("Êtes-vous sûr de vouloir supprimer cette communauté ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );

    // If user confirmed the deletion
    if (shouldDelete == true) {
      try {
        final projectId = model.projectId;
        final communityId = model.communityId;

        await provider.deleteCommunity(projectId, communityId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Communauté supprimée avec succès !")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression de la communauté: $e")),
        );
      }
    }
  },
),

      ],
    );
  }
void _showEditDialog(BuildContext context) {

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  TextEditingController nameController = TextEditingController(text: model.name);
  TextEditingController descriptionController = TextEditingController(text: model.description);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Modifier Communauté'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: nameController,
                  hintText: 'Nom de la communauté',
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: descriptionController,
                  hintText: 'Description',
                ),
                SizedBox(height: 10),
                _selectedImage != null
                    ? Image.file(
                        File(_selectedImage!.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        model.imageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_image.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _selectedImage = pickedImage;
                      });
                    }
                  },
                ),
              ],
            ),
           actions: [
  TextButton(
    onPressed: () => Navigator.of(context).pop(),
    style: TextButton.styleFrom(
      foregroundColor: Colors.grey, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
    child: Text(
      'Annuler',
      style: TextStyle(fontSize: 16), // Font size
    ),
  ),
  ElevatedButton(
    onPressed: () async {
      final newName = nameController.text;
      final newDescription = descriptionController.text;

      final provider = Provider.of<ListeDeCommunautProvider>(context, listen: false);
      await provider.updateCommunity(
        model.projectId,
        model.communityId,
        newName,
        newDescription,
        _selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Communauté mise à jour avec succès!")),
      );

      Navigator.of(context).pop();
    },
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: Colors.lightGreenAccent, // Text color
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
    child: Text(
      'Enregistrer',
      style: TextStyle(fontSize: 16), // Font size
    ),
  ),
],

          );
        },
      );
    },
  );
}
  
  }

