import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/screens/affichage_par_categorie/models/listtext_item_model.dart';

class AffichageCategoriePage extends StatefulWidget {
  const AffichageCategoriePage({super.key, required this.categoryName});
  final String categoryName;

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AffichageCategorieProvider(),
      child: const AffichageCategoriePage(categoryName: ""),
    );
  }

  @override
  AffichageCategoriePageState createState() => AffichageCategoriePageState();
}

class AffichageCategoriePageState extends State<AffichageCategoriePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the projects related to the category when the page is loaded.
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<AffichageCategorieProvider>(context, listen: false);
      provider.fetchProjectsByCategory(
          widget.categoryName); // Fetch projects by category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMaleUserOneRow(context),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 26.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 48.v),
                    _buildRowListedeOneSection(context),
                    SizedBox(height: 17.v),
                    Expanded(
                      child: Consumer<AffichageCategorieProvider>(
                        builder: (context, provider, child) {
                          // If projects are loading, show a loading indicator
                          if (provider.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }

                          // If there was an error, display the error message
                          if (provider.errorMessage.isNotEmpty) {
                            return Center(child: Text(provider.errorMessage));
                          }

                          // If no projects available, show a message
                          if (provider.filteredProjects.isEmpty) {
                            return Center(child: Text("Aucun projet trouvé"));
                          }

                          // Display projects after applying the filter
                          return SingleChildScrollView(
                            child: Column(
                              children: provider.filteredProjects.isNotEmpty
                                  ? provider.filteredProjects.map((project) {
                                      return _buildProjetNrgColumn(context,
                                          project: project);
                                    }).toList()
                                  : [Text("Aucun projet trouvé")],
                            ),
                          );
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
                            NavigatorService.pushNamedAndRemoveUntil(
                                RoutePath.welcomeScreen);
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
                              ? NetworkImage(
                                  provider.profileImageUrl! as String)
                              : const AssetImage('assets/images/avatar.png')
                                  as ImageProvider,
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
            Selector<AffichageCategorieProvider, TextEditingController?>(
              selector: (context, provider) => provider.searchController,
              builder: (context, searchController, child) {
                return TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher",
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  Widget _buildRowListedeOneSection(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 18,
          splashRadius: 16,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          "Liste des projets".tr,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildProjetNrgColumn(BuildContext context,
      {required ListtextItemModel1 project}) {
    return Column(
      children: [
        SizedBox(height: 15.v),
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: appTheme.lightGreen600, width: 5.h),
            borderRadius: BorderRadiusStyle.roundedBorder20,
          ),
          child: Container(
            height: 240.v,
            width: 340.h,
            decoration: AppDecoration.outlineLightgreen6002.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder20,
            ),
            child: Stack(
              children: [
                _buildProjetAgricoleStack(context,
                    imageFour: project.images.toString() ?? ""),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 32.h, right: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.h, vertical: 8.v),
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
                            project.category ?? "lbl_projet_n_rgie".tr,
                            style: CustomTextStyles.titleLargeBold,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 27.h),
                          child: Text(
                            "msg_grand_projet_n_rg_tique".tr,
                            style: CustomTextStyles.bodyMediumLight_1,
                          ),
                        ),
                        SizedBox(height: 8.v),
                        Padding(
                          padding: EdgeInsets.only(left: 27.h),
                          child: Text(
                            "lbl_80_000".tr,
                            style: CustomTextStyles.titleLargeLightgreen600,
                          ),
                        ),
                        SizedBox(height: 9.v),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjetAgricoleStack(BuildContext context,
      {required String imageFour}) {
    return SizedBox(
      height: 258.v,
      width: 193.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle117,
            height: 258.v,
            width: 193.h,
            radius: BorderRadius.horizontal(left: Radius.circular(15.h)),
            alignment: Alignment.center,
          ),
          CustomImageView(
            imagePath: imageFour,
            height: 258.v,
            width: 193.h,
            radius: BorderRadius.horizontal(left: Radius.circular(20.h)),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
