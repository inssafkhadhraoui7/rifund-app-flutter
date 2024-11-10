import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import 'models/userprofile_item_model.dart';
import 'provider/membre_rejoindre_provider.dart';
import 'widgets/userprofile_item_widget.dart';

class MembreRejoindreScreen extends StatefulWidget {
  final String userId;
  final String projectId;
  final String communityId;

  const MembreRejoindreScreen({
    Key? key,
    required this.userId,
    required this.projectId,
    required this.communityId,
  }) : super(key: key);

  @override
  MembreRejoindreScreenState createState() => MembreRejoindreScreenState();

  static Widget builder(BuildContext context, {required String userId, required String projectId, required String communityId}) {
    return ChangeNotifierProvider(
      create: (context) => MembreRejoindreProvider(),
      child: MembreRejoindreScreen(
        userId: userId,
        projectId: projectId,
        communityId: communityId,
      ),
    );
  }
}

class MembreRejoindreScreenState extends State<MembreRejoindreScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MembreRejoindreProvider>(context, listen: false);
    provider.fetchMembersByCommunity(widget.communityId,widget.userId,widget.projectId);
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
              SizedBox(height: 37),
              _buildUserProfile(context),
            ],
          ),
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
            onPressed: () => Navigator.pop(context),
          ),
          AppbarTitle(
            text: "Membres à rejoindre",
            margin: EdgeInsets.only(left: 50, top: 2, right: 40),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Consumer<MembreRejoindreProvider>(builder: (context, provider, child) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 23),
            itemCount: provider.membreRejoindreModelObj.userprofileItemList.length,
            itemBuilder: (context, index) {
              UserprofileItemModel model = provider.membreRejoindreModelObj.userprofileItemList[index];
              return UserprofileItemWidget(
                model: model,
                provider: provider,
                communityId: widget.communityId,
                userId: widget.userId,  // Pass userId
                projectId: widget.projectId,  // Pass projectId
              );
            },
          );
        }),
      ),
    );
  }
}
