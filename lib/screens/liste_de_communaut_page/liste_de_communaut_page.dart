import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../liste_de_communaut_page/provider/liste_de_communaut_provider.dart';
import 'widgets/communitycardsection_item_widget.dart'; // ignore_for_file: must_be_immutable

class ListeDeCommunautPage extends StatefulWidget {
  @override
  _ListeDeCommunautPageState createState() => _ListeDeCommunautPageState();

  static builder(BuildContext context) {}
}

class _ListeDeCommunautPageState extends State<ListeDeCommunautPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<ListeDeCommunautProvider>(context, listen: false);
      provider.fetchAllCommunities(); // Call to fetch communities
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.orange50,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => NavigatorService.goBack(),
          ),
          AppbarTitle(
            text: "Liste des Communautés".tr,
            margin: EdgeInsets.only(left: 50.h, top: 2.v, right: 40.h),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillOrange,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.h),
              child: Column(
                children: [
                  SizedBox(height: 48.v),
                  _buildRowListedeOneSection(context),
                  SizedBox(height: 17.v),
                  _buildCommunityCardSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


Widget _buildRowListedeOneSection(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.h),
        child: Text(
          "Liste des Communautés".tr,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold, // Emphasize the title with bold text
            fontSize: 24, // Slightly larger font size for better readability
          ),
        ),
      ),
      SizedBox(height: 20), // Add space between the text and the row of buttons
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
        children: [
          // My Communities button
            CustomElevatedButton(
                              height: 20.v,
                              text: "My communities".tr,
                              margin: EdgeInsets.only(
                                left: 35.h,
                                right: 20.h,
                              ),
                              onPressed: () {
                              
                              },
                              buttonStyle: CustomButtonStyles.fillWhiteA,
                              buttonTextStyle:
                                  CustomTextStyles.titleLargeSemiBold,
                            ),
          SizedBox(width: 15), // Add space between the buttons
          // Join Communities button
         CustomElevatedButton(
                              height: 20.v,
                              text: "My communities".tr,
                              margin: EdgeInsets.only(
                                left: 35.h,
                                right: 20.h,
                              ),
                              onPressed: () {
                              
                              },
                              buttonStyle: CustomButtonStyles.fillWhiteA,
                              buttonTextStyle:
                                  CustomTextStyles.titleLargeSemiBold,
                            ),
        ],
      ),
    ],
  );
}

 Widget _buildCommunityCardSection(BuildContext context) {
  final String idUser = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user ID

  return Expanded(
    child: Padding(
      padding: EdgeInsets.only(left: 3.h, right: 5.h),
      child: Consumer<ListeDeCommunautProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }
          if (provider.communities.isEmpty) {
            return Center(child: Text("Pas de communautés"));
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(height: 18.h),
            itemCount: provider.communities.length,
            itemBuilder: (context, index) {
              final community = provider.communities[index];
              final communityId = community.communityId;
              final projectId = community.projectId ?? ''; // Retrieve projectId if available in model

              return CommunitycardsectionItemWidget(
                model: community,
                communityId: communityId,
                projectId: projectId, // Pass the project ID
                userId: idUser,       // Pass the user ID
              );
            },
          );
        },
      ),
    ),
  );
}



}
