import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_export.dart';
import '../screens/cr_er_communaut_screen/cr_er_communaut_screen.dart';
import '../screens/listeprojets/models/userprofile_item_model.dart';
import '../screens/listeprojets/provider/liste_des_projets_provider.dart';
import '../screens/modifierscreen/modifierprojetscreen.dart';

// ignore_for_file: must_be_immutable
class UserprofileItemWidget extends StatelessWidget {
  final UserprofileItemModel userprofileItemModelObj;

  UserprofileItemWidget(this.userprofileItemModelObj, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the user profile model is initialized
    if (userprofileItemModelObj == null) {
      return Container(); // Handle null case
    }

    // Debugging: Log model properties
    print("ID: ${userprofileItemModelObj.id}");
    print("Titre du projet: ${userprofileItemModelObj.titreduprojet}");
    print("Circle Image: ${userprofileItemModelObj.circleimage}");
    print("Seventy: ${userprofileItemModelObj.seventy}");

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 127.v,
        width: 314.h,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60.h,
                margin: EdgeInsets.only(left: 75.h, right: 45.h, bottom: 27.v),
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                decoration: AppDecoration.fillBlueGray.copyWith(
                  borderRadius: BorderRadiusStyle.circleBorder7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 1.v),
                    Text(
                      userprofileItemModelObj.seventy ?? "0 %",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 14.v,
                width: 141.h,
                margin: EdgeInsets.only(bottom: 27.v),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(7.h),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 8.v),
                decoration: AppDecoration.outlinePrimary.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 14),
                    CustomImageView(
                      imagePath: userprofileItemModelObj.circleimage!,
                      height: 58.adaptSize,
                      width: 58.adaptSize,
                      radius: BorderRadius.circular(29.h),
                      margin: EdgeInsets.only(top: 3.v, bottom: 17.v),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 17.h, top: 1.v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.v),
                                  child: Text(
                                    userprofileItemModelObj.titreduprojet ?? "Titre du projet",
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                SizedBox(
                                  height: 32.adaptSize,
                                  width: 32.adaptSize,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, userprofileItemModelObj.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 11.v),
                            SizedBox(
                              height: 32.adaptSize,
                              width: 32.adaptSize,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModifierProjetScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 32.adaptSize,
                              width: 32.adaptSize,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.people, color: Colors.black),
                                onPressed: () async {
                                  // Ensure user profile object is initialized
                                  final projectId = userprofileItemModelObj.id;

                                  // Log project ID for debugging
                                  print('Project ID from UserProfile: $projectId');

                                  // Navigate only if projectId is valid
                                  if (projectId != null && projectId.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      '/cr_er_communaut_screen',
                                      arguments: projectId,
                                    );
                                  } else {
                                    print('Project ID is null or empty!'); // Log this error
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String? projectId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous supprimer ce projet ?"),
          actions: [
            TextButton(
              onPressed: () {
                if (projectId != null && projectId.isNotEmpty) {
                  _deleteProject(projectId, context);
                }
                Navigator.of(context).pop();
              },
              child: Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProject(String projectId, BuildContext context) {
    final provider = Provider.of<ListeDesProjetsProvider>(context, listen: false);
    provider.deleteProject(projectId); // Implement this method in your provider
  }
}
