import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/theme/custom_button_style.dart';
import 'package:rifund/widgets/app_bar/custom_app_bar.dart';
import 'package:rifund/widgets/bottomNavBar.dart';
import 'package:rifund/widgets/custom_elevated_button.dart';

import '../../../../widgets/app_bar/appbar_title.dart';
import 'models/admin_projet_model.dart';

class AdminProjetScreen extends StatefulWidget {
  const AdminProjetScreen({super.key});

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
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage.isNotEmpty
                  ? Center(child: Text(provider.errorMessage))
                  : provider.projects.isEmpty
                      ? const Center(child: Text("Pas de projets."))
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
    final provider = Provider.of<AdminProjetProvider>(context, listen: false);

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
          if (project.images != null && project.images!.isNotEmpty)
            Center(
              child: CachedNetworkImage(
                imageUrl: project.images!.first,
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
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          SizedBox(height: 10.v),
          Center(
            child: Text(
              project.title ?? '',
              style: theme.textTheme.titleLarge,
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
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
                if (!project.isApproved) ...[
                  CustomElevatedButton(
                    width: 104.h,
                    height: 45.v,
                    text: "Valider".tr,
                    buttonTextStyle: CustomTextStyles.bodyMediumBlack900!,
                    onPressed: () async {
                      await provider.approveProject(project);
                      provider.fetchProjects();
                    },
                  ),
                  CustomElevatedButton(
                    width: 104.h,
                    height: 45.v,
                    text: "Refuser".tr,
                    margin: EdgeInsets.only(left: 8.h),
                    buttonStyle: CustomButtonStyles.fillGray,
                    buttonTextStyle: CustomTextStyles.bodyMediumBlack900,
                    onPressed: () async {
                      _showDeleteDialog1(context, provider, project);
                    },
                  ),
                ] else ...[
                  CustomElevatedButton(
                    width: 104.h,
                    height: 45.v,
                    text: "Supprimer".tr,
                    buttonStyle: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    buttonTextStyle: CustomTextStyles.bodyMediumBlack900,
                    onPressed: () async {
                      _showDeleteDialog(context, provider, project);
                    },
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AdminProjetProvider provider,
      AdminProjetModel project) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr de vouloir supprimer ce projet ?'),
          content: Text('Cette action va supprimer le projet definitivement'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await provider.rejectProject(project);
                Navigator.pop(context);
                provider.fetchProjects();
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

void _showDeleteDialog1(BuildContext context, AdminProjetProvider provider,
      AdminProjetModel project) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr de vouloir refuser ce projet ?'),
          content: Text('Cette action va supprimer le projet definitivement'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await provider.rejectProject(project);
                Navigator.pop(context);
                provider.fetchProjects();
              },
              child: Text('Refuser'),
            ),
          ],
        );
      },
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
          Flexible(
            child: Text(
              value.tr,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
