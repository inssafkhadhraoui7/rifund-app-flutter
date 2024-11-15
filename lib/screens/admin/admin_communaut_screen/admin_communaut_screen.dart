import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/admin/admin_communaut_screen/provider/admin_communaut_provider.dart';

import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'models/admin_communaut_model.dart';

class AdminCommunautScreen extends StatefulWidget {
  const AdminCommunautScreen({Key? key}) : super(key: key);

  @override
  AdminCommunautScreenState createState() => AdminCommunautScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminCommunautProvider(),
      child: const AdminCommunautScreen(),
    );
  }
}

class AdminCommunautScreenState extends State<AdminCommunautScreen> {
  late AdminCommunautProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AdminCommunautProvider>(context, listen: false);
    provider.fetchCommunities();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: _buildContent(context),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => onTapArrowLeft(context),
          ),
          Expanded(
            child: AppbarTitle(
              text: "Gérer communautés".tr,
              margin: EdgeInsets.only(left: 60.h, top: 2.v, right: 79.h),
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<AdminCommunautProvider>(
      builder: (context, provider, child) {
        return provider.communities.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: provider.communities.length,
                itemBuilder: (context, index) {
                  final community = provider.communities[index];
                  return _buildCommunityCard(context, community);
                },
              );
      },
    );
  }

Widget _buildCommunityCard(BuildContext context, AdminCommunautModel community) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        children: [
          // Center the image
         Column(
  crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
  children: [
    CustomImageView(
      imagePath: community.webUrl.isNotEmpty ? community.webUrl : ImageConstant.imgImage41,
      height: 108.v,
      width: 217.h,
      radius: BorderRadius.circular(20.h),
    ),
    SizedBox(height: 8.0), // Add space between image and date
    Text(
      'Crée à : ${community.createdAt.toLocal().toString()}',
      style: TextStyle(fontSize: 14, color: Colors.black), // Adjust text style as needed
      textAlign: TextAlign.center, // Center the date text
    ),
  ],
),

          SizedBox(height: 8.v), // Add space between image and name
          // Community name centered below the image
        Text(
  'Nom de la communauté : ${community.name ?? "Community Name not available"}',
  textAlign: TextAlign.center, // Center the name
  style: Theme.of(context).textTheme.titleLarge,
),
          SizedBox(height: 21.v),
          _buildRowDescription(context, community),
          SizedBox(height: 1.v),
          _buildRowNomDeProjet(context, community),
          SizedBox(height: 6.v),
          _buildActionButtons(context, community),
          SizedBox(height: 5.v),
        ],
      ),
    ),
  );
}


  Widget _buildRowDescription(BuildContext context, AdminCommunautModel community) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 53.v),
            child: Text(
              "Description :".tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(width: 19.h),
          Expanded(
            child: Text(
              community.description.isEmpty
                  ? 'No description available'
                  : community.description,
              overflow: TextOverflow.visible,
              style: CustomTextStyles.bodyMediumBlack900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowNomDeProjet(BuildContext context, AdminCommunautModel community) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 40.v),
            child: Text(
              "Nom de projet :".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(width: 19.h),
          Expanded(
            child: Text(
              community.name.isEmpty ? 'No name available' : community.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyMediumBlack900,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildActionButtons(BuildContext context, AdminCommunautModel community) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 45.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomElevatedButton(
            height: 36.v,
            width: 104.h,
            text: "Valider".tr,
            buttonTextStyle: CustomTextStyles.bodyMediumBlack900,
            onPressed: () {
              // Ensure that provider is accessed properly
              provider.updateCommunityStatus(
                community.userId,
                community.projectId,
                community.id,
                true, context,
              );
            },
          ),
        ),
        SizedBox(width: 9.h),
        Expanded(
          child: CustomElevatedButton(
            height: 36.v,
            width: 104.h,
            text: "Refuser".tr,
            buttonStyle: CustomButtonStyles.fillGray,
            buttonTextStyle: CustomTextStyles.bodyMediumBlack900,
            onPressed: () {
              // Ensure that provider is accessed properly
              provider.updateCommunityStatus(
                community.userId,
                community.projectId,
                community.id,
                false, context,
              );
            },
          ),
        ),
      ],
    ),
  );
}



  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
