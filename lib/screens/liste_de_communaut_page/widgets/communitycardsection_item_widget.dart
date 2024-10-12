import 'package:flutter/material.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/screens/membre_rejoindre_screen/membre_rejoindre_screen.dart';
import 'package:rifund/screens/modifier_communaut_screen/modifier_communaut_screen.dart';
import '../../../core/app_export.dart';
import '../models/communitycardsection_item_model.dart'; // ignore: must_be_immutable
class CommunitycardsectionItemWidget extends StatelessWidget {
  final CommunitycardsectionItemModel model;

  const CommunitycardsectionItemWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.h, vertical: 3.v),
      decoration: AppDecoration.outlineWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display image from the URL
          CustomImageView(
            imagePath: model.imageUrl,
            height: 99.v,
            width: 93.h,
            radius: BorderRadius.circular(12.h),
            margin: EdgeInsets.only(top: 10.v, bottom: 15.v),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h, top: 10.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: CustomTextStyles.titleSmallSemiBold,
                ),
                SizedBox(height: 12.v),
                // Display the description
                Text(
                  model.description,  // Display the description
                  style: theme.textTheme.bodyMedium,  // Style for description
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_document),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ModifierCommunautScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.group_add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MembreRejoindreScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatBoxScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.orange50,
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous supprimer cette communauté ?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Supprimer",
                style: TextStyle(color: Color.fromARGB(255, 118, 173, 55)),
              ),
              onPressed: () {
                _deleteItem();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Annuler", style: TextStyle(color: Color.fromARGB(255, 118, 173, 55))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem() {
    print("Communauté supprimée!");
  }
}

