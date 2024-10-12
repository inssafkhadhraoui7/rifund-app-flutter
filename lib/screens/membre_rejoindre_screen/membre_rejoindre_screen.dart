import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import 'models/userprofile_item_model.dart';
import 'provider/membre_rejoindre_provider.dart';
import 'widgets/userprofile_item_widget.dart';

class MembreRejoindreScreen extends StatefulWidget {
  const MembreRejoindreScreen({Key? key}) : super(key: key);

  @override
  MembreRejoindreScreenState createState() => MembreRejoindreScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MembreRejoindreProvider(),
      child: MembreRejoindreScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class MembreRejoindreScreenState extends State<MembreRejoindreScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 37.v),
              _buildUserProfile(context)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapImage(context);
            },
          ),
          AppbarTitle(
            text: "Membres à rejoindre".tr,
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

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 30.h,
          right: 23.h,
        ),
        child: Consumer<MembreRejoindreProvider>(builder: (context, provider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('participants').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No participants found.'));
              }

              // Map the snapshot data to your user profile items
              provider.participants = snapshot.data!.docs.map((doc) {
                return UserprofileItemModel.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 23.v);
                },
                itemCount: provider.participants.length,
                itemBuilder: (context, index) {
                  UserprofileItemModel model = provider.participants[index];
                  return UserprofileItemWidget(model);
                },
              );
            },
          );
        }),
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapImage(BuildContext context) {
    NavigatorService.goBack();
  }
}
