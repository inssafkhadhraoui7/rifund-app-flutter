import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/ajout_cat_gorie_page/ajout_cat_gorie_page.dart';
import 'package:rifund/screens/admin/modifier_cat_gorie_page/modifier_cat_gorie_page.dart';

import '../../../../widgets/app_bar/appbar_title.dart';
import '../../../core/app_export.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_icon_button.dart';
import 'provider/admin_cat_gorie_provider.dart';

class AdminCatGorieScreen extends StatefulWidget {
  const AdminCatGorieScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AdminCatGorieScreenState createState() => AdminCatGorieScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminCatGorieProvider(),
      child: AdminCatGorieScreen(),
    );
  }
}

class AdminCatGorieScreenState extends State<AdminCatGorieScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  void onTapBtnPlusOne(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AdminCatGorieProvider>(context, listen: false);
    provider
        .fetchCategories(); // Fetch categories when the screen is initialized
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
            SizedBox(height: 28.v),
            Padding(
              padding: EdgeInsets.only(
                left: 23.h,
                right: 17.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.v),
                    child: Text(
                      "Liste des catégories".tr,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AjoutCatGoriePage()),
                      );
                    },
                    child: Icon(Icons.add, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(19),
                      backgroundColor: Colors.lightGreen.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AdminCatGorieProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  return SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          SizedBox(height: 28.v),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 25.h),
                              child: Column(
                                children: [
                                  SizedBox(height: 25.v),
                                  // Display dynamic categories
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: provider.categories.length,
                                    itemBuilder: (context, index) {
                                      final category =
                                          provider.categories[index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.h,
                                            right: 2.h,
                                            bottom: 10.v),
                                        child: _buildField1(
                                          context,
                                          text: category.name,
                                          imageUrl: category.imageUrl,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    ));
  }
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
          text: "Gérer catégories".tr,
          margin: EdgeInsets.only(
            left: 80.h,
            top: 2.v,
            right: 79.h,
          ),
        ),
      ],
    ),
    styleType: Style.bgFill_1,
  );
}

Widget _buildField1(
  BuildContext context, {
  required String text,
  required String imageUrl,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
    decoration: AppDecoration.outlineLightgreen600.copyWith(
      borderRadius: BorderRadiusStyle.roundedBorder20,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 9.0),
          child: Image.network(
            imageUrl, // Use the imageUrl from the category
            height: 24.0,
            width: 24.0,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8.0),
        Padding(
          padding: EdgeInsets.only(top: 7.0, bottom: 9.0),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: appTheme.black900,
            ),
          ),
        ),
        Spacer(),
        CustomIconButton(
          height: 32.0,
          width: 32.0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ModifierCatGoriePage()),
            );
          },
          child: Icon(Icons.note_add),
        ),
        SizedBox(width: 8.0),
        CustomIconButton(
          height: 32.0,
          width: 32.0,
          onTap: () {
            deletedialog(context);
          },
          child: Icon(Icons.delete),
        ),
      ],
    ),
  );
}

void onTapArrowleftone(BuildContext context) {
  NavigatorService.goBack();
}

void onTapBtnPlusone(BuildContext context) {}

void deletedialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous supprimer cette catégorie"),
          actions: [
            TextButton(
              onPressed: () {
                // Perform delete operation here
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
      });
}
