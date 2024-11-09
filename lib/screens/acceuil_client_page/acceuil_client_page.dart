import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/screens/affichage_par_categorie/affichagecategorie.dart';
import 'package:rifund/screens/details_projet_screen/details_projet_screen.dart';
import 'package:rifund/widgets/custom_search_view.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../financer_projet_screen/financer_projet_screen.dart';
import 'models/listtext_item_model.dart';

class AcceuilClientPage extends StatefulWidget {
  const AcceuilClientPage({super.key});

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AcceuilClientProvider(),
      child: const AcceuilClientPage(),
    );
  }

  @override
  AcceuilClientPageState createState() => AcceuilClientPageState();
}

class AcceuilClientPageState extends State<AcceuilClientPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AcceuilClientProvider>(context, listen: false)
          .fetchAllProjects();
      Provider.of<AcceuilClientProvider>(context, listen: false)
          .fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      //   resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMaleUserOneRow(context),
          SizedBox(height: 47.v),
          Padding(
            padding: EdgeInsets.only(left: 15.h),
            child: Text(
              "lbl_cat_gories".tr,
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          _buildCategoriesColumn(context),
          SizedBox(height: 20.v),
          Padding(
            padding: EdgeInsets.only(left: 15.h),
            child: Text(
              "msg_projets_financ_s".tr,
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          SizedBox(height: 20.v),
          Padding(
            padding: EdgeInsets.only(left: 15.v),
            child: _buildProjetNrgColumn(context),
          ),
          SizedBox(height: 5.v),
        ],
      ),
    );
  }

  Widget _buildMaleUserOneRow(BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 27, vertical: 13),
      decoration: AppDecoration.fillLightGreen.copyWith(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Consumer<AcceuilClientProvider>(
                  builder: (context, provider, child) {
                    return PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 'logout') {
                          await FirebaseAuth.instance.signOut();
                          NavigatorService.pushNamedAndRemoveUntil(RoutePath.welcomeScreen);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Deconnexion'),
                            ],
                          ),
                        ),
                      ],
                child: CircleAvatar(
  radius: 30,
  backgroundImage: provider.profileImageUrl != null
      ? NetworkImage(provider.profileImageUrl! as String)
      : const AssetImage('assets/images/avatar.png') as ImageProvider,
),

                    );
                  },
                ),
                SizedBox(width: 11),
                Container(
                  width: 111,
                  margin: EdgeInsets.only(left: 11, top: 12, bottom: 3),
                  child: Consumer<AcceuilClientProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        provider.userName.isEmpty
                            ? "Nom d'utilisateur"
                            : provider.userName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.titleLargeWhiteA700,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 9),
          Selector<AcceuilClientProvider, TextEditingController?>(
            selector: (context, provider) => provider.searchController,
            builder: (context, searchController, child) {
              return TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Rechercher",
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
  Widget _buildCategoriesColumn(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 21.v),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 115.v,
              child: Consumer<AcceuilClientProvider>(
                  builder: (context, provider, child) {
                final categoryItems = provider.listcategoryItemList;

                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryItems.isEmpty) {
                  return const Center(child: Text('Pas de catégories'));
                }

                return ListView.separated(
                  padding: EdgeInsets.only(left: 24.h),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 20.h),
                  itemCount: categoryItems.length,
                  itemBuilder: (context, index) {
                    CategoryItemModel model = categoryItems[index];

                    String imageUrl = model.images?.isNotEmpty == true
                        ? model.images!.first
                        : '';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AffichageCategoriePage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 180,
                        height: 130,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                          ),
                          decoration:
                              AppDecoration.outlineLightgreen6001.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder20,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10.v),
                              CustomImageView(
                                alignment: Alignment.center,
                                imagePath: imageUrl,
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(height: 9.v),
                              Text(model.name!,
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.titleSmallSemiBold)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjetNrgColumn(BuildContext context) {
    return Consumer<AcceuilClientProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.filteredProjects.isEmpty) {
          return const Center(child: Text("Pas de projets."));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: provider.filteredProjects.map((project) {
              String imageFour =
                  (project.images != null && project.images!.isNotEmpty)
                      ? project.images!.first
                      : ImageConstant.imgRectangle117;
              return SizedBox(
                width: 340.h,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: EdgeInsets.only(left: 10.h),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: appTheme.lightGreen600, width: 5.h),
                    borderRadius: BorderRadiusStyle.roundedBorder20,
                  ),
                  child: Container(
                    height: 240.v,
                    decoration: AppDecoration.outlineLightgreen6002.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                    ),
                    child: Stack(
                      children: [
                        _buildProjetAgricoleStack(
                          context,
                          imageFour: imageFour,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(left: 32.h, right: 20.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.h, vertical: 8.v),
                            decoration: AppDecoration.outlineBlack9002.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 27.h),
                                  child: Text(
                                    project.title ?? "Titre du projet",
                                    style: CustomTextStyles.titleLargeBold,
                                  ),
                                ),
                                SizedBox(height: 11.v),
                                Padding(
                                  padding: EdgeInsets.only(left: 27.h),
                                  child: Text(
                                    project.budget != null
                                        ? project.budget.toString()
                                        : "Pas de budget",
                                    style: CustomTextStyles
                                        .titleLargeLightgreen600,
                                  ),
                                ),
                                SizedBox(height: 9.v),
                                Container(
                                  height: 14.v,
                                  width: 177.h,
                                  margin: EdgeInsets.only(left: 27.h),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 14.v,
                                          width: 176.h,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme
                                                .onSecondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(7.h),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.v),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomElevatedButton(
                                        height: 45.v,
                                        width: 130.h,
                                        text: "lbl_faire_un_don".tr,
                                        buttonTextStyle: CustomTextStyles
                                            .titleMediumWhiteA700,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const FinancerProjetScreen()),
                                          );
                                        },
                                      ),
                                      SizedBox(width: 5.h),
                                      CustomElevatedButton(
                                        height: 45.v,
                                        width: 75.h,
                                        text: "lbl_plus".tr,
                                        buttonStyle:
                                            CustomButtonStyles.fillGray,
                                        buttonTextStyle:
                                            theme.textTheme.titleMedium!,
                                        onPressed: () {
                                          log("project : userid : ${project.userId} and projectId : ${project.id}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsProjetScreen(
                                                      project: project),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildProjetAgricoleStack(
    BuildContext context, {
    required String imageFour,
  }) {
    return SizedBox(
      height: 258.v,
      width: 193.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: imageFour,
            height: 258.v,
            width: 193.h,
            radius: BorderRadius.horizontal(left: Radius.circular(15.h)),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
