import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/core/utils/navigator_service.dart';
import 'package:rifund/screens/affichage_communaut_page/provider/affichage_communaut_provider.dart';
import 'package:rifund/widgets/app_bar/appbar_title.dart';
import 'package:rifund/widgets/app_bar/custom_app_bar.dart';

class AffichageCommunautPage extends StatefulWidget {
  final String communityId;
  final String userId;
  final String projectId;

  const AffichageCommunautPage({Key? key, required this.userId, required this.projectId, required this.communityId})
      : super(key: key);

  @override
  _AffichageCommunautPageState createState() => _AffichageCommunautPageState();
}

class _AffichageCommunautPageState extends State<AffichageCommunautPage> {
  @override
  void initState() {
    super.initState();

    // Call fetchCommunityDetails after the widget is built
    Future.microtask(() {
      final provider =
          Provider.of<AffichageCommunautProvider>(context, listen: false);
      provider.fetchCommunityDetails();
    });
  }

 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: Consumer<AffichageCommunautProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.hasError) {
            return Center(child: Text(provider.errorMessage));
          } else {
            return Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 20.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                   child: provider.communityImage.isNotEmpty
                      ? ClipRRect(
                     borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                         child: Image.network(
                      provider.communityImage,
                     height: 200.v,
                    width: 250.h,
                fit: BoxFit.cover,
                ),
                   )
                        : Placeholder(
                            fallbackHeight: 100.v,
                            fallbackWidth: 150.h,
                          ), // Placeholder if no image
                  ),
                  SizedBox(height: 5.v),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 36.h),
                      child: Text(
                        provider.creationDate,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 28.h),
                    child: Text(
                      "lbl_a_propos".tr,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 4.v),
                  Padding(
                    padding: EdgeInsets.only(left: 28.h),
                    child: Text(
                      provider.communityDescription,
                      style: CustomTextStyles.titleLargeLight,
                    ),
                  ),
                SizedBox(height: 13.v),
                Center(
                 child: IconButton(
         icon: Icon(Icons.exit_to_app), // Replace with your desired icon
             onPressed: () {
                 // Show the dialog when the icon is pressed
                 showDialog(
                   context: context,
              builder: (BuildContext context) {
                  return AlertDialog(
                  title: Text("Voulez-vous quitter cette communauté?"),
                  content: Text("Êtes-vous sûr de vouloir quitter cette communauté?"),
                             actions: <Widget>[
                    TextButton(
                       child: Text("Annuler"),
                    onPressed: () {
                             Navigator.of(context).pop(); // Close the dialog
                     },
                    ),
                    TextButton(
                      child: Text("Quitter"),
                     onPressed: () {
                  // Implement your logic to leave the community here

                  // Close the dialog
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  ),
),
                ],
              ),
            );
          }
        },
      ),
    ),
  );
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    centerTitle: true,
    title: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () {
            onTapArrowleftone(context);
          },
        ),
        AppbarTitle(
          text: "Communauté details".tr,
          margin: EdgeInsets.only(
            left: 50.h,
            top: 2.v,
            right: 40.h,
          ),
        ),
      ],
    ),
    styleType: Style.bgFill_1,
  );
}




  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }

}
