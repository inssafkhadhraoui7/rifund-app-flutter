import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../profile_admin_page/profile_admin_page.dart';
import 'models/admin_projet_model.dart';
import 'provider/admin_projet_provider.dart';

class AdminProjetScreen extends StatefulWidget {
  const AdminProjetScreen({Key? key}) : super(key: key);

  @override
  AdminProjetScreenState createState() => AdminProjetScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProjetProvider(),
      child: const AdminProjetScreen(),
    );
  }
}

class AdminProjetScreenState extends State<AdminProjetScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AdminProjetProvider>(context, listen: false);
      provider.fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProjetProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.infinity,
          child: provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.errorMessage.isNotEmpty
                  ? Center(child: Text(provider.errorMessage))
                  : provider.projects.isEmpty
                      ? Center(child: Text("Pas de projets."))
                      : ListView.builder(
                          itemCount: provider.projects.length,
                          itemBuilder: (context, index) {
                            final project = provider.projects[index];
                            return _buildProjectCard(project);
                          },
                        ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  Widget _buildProjectCard(AdminProjetModel project) {
    return Container(
      width: 337.h,
      margin: EdgeInsets.symmetric(horizontal: 11.h, vertical: 10.h),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the first image only if available
          if (project.images != null && project.images!.isNotEmpty)
            Center(
              child: CachedNetworkImage(
                imageUrl: project.images!.first, // Get the first image
                height: 118.v,
                width: 237.h,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.h),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          SizedBox(height: 10.v),
          Center(
            child: Text(
              project.title ?? '',
              style: theme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 15.v),
          _buildInfoRow(context, "Description:", project.description ?? ''),
          SizedBox(height: 15.v),
          _buildInfoRow(context, "Catégorie:", project.category ?? ''),
          SizedBox(height: 15.v),
          _buildInfoRow(
            context,
            "Date:",
            project.date != null
                ? DateFormat('yyyy-MM-dd').format(project.date!)
                : 'N/A',
          ),
          SizedBox(height: 15.v),
          _buildInfoRow(
            context,
            "Budget:",
            project.budget != null ? project.budget!.toStringAsFixed(2) : 'N/A',
          ),
          SizedBox(height: 19.v),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  width: 104.h,
                  height: 45.v,
                  text: "Valider".tr,
                  buttonTextStyle: CustomTextStyles.bodyMediumBlack900!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileAdminPage(),
                      ),
                    );
                  },
                ),
                CustomElevatedButton(
                  width: 104.h,
                  height: 45.v,
                  text: "Refuser".tr,
                  margin: EdgeInsets.only(left: 8.h),
                  buttonStyle: CustomButtonStyles.fillGray,
                  buttonTextStyle: CustomTextStyles.bodyMediumBlack900,
                  onPressed: () {
                    onTapArrowleftone(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 4.v),
        ],
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
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarTitle(
            text: "Gérer Projets".tr,
            margin: EdgeInsets.only(left: 80.h, right: 79.h),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(left: 12.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 3.v),
            child: Text(
              label.tr,
              style: CustomTextStyles.titleLargeMedium,
            ),
          ),
          SizedBox(width: 8.h),
          Text(
            value.tr,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
