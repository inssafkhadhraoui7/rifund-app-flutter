import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/cr_er_communaut_provider.dart';

class CrErCommunautScreen extends StatefulWidget {
  final String projectId;

  const CrErCommunautScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  CrErCommunautScreenState createState() => CrErCommunautScreenState();

  static Widget builder(BuildContext context, projectId) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = CrErCommunautProvider();
        provider.setProjectId(projectId);
        return provider;
      },
      child: CrErCommunautScreen(projectId: projectId),
    );
  }
}

class CrErCommunautScreenState extends State<CrErCommunautScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 54.v),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                    vertical: 33.v,
                  ),
                  decoration: AppDecoration.outlineLightGreen.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 34.v),
                      SizedBox(
                        width: 156.h,
                        child: Text(
                          "msg_cr_er_communaut".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(height: 20.v),
                      _buildCreateCommunity(context),
                      SizedBox(height: 16.v),
                      _buildDescriptionValue(context),
                      SizedBox(height: 17.v),
                      _buildWebUrl(context),
                      SizedBox(height: 29.v),
                      Padding(
                        padding: EdgeInsets.only(left: 13.h, right: 18.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCreateButton(context),
                            _buildCancelButton(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.v)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapImage(context);
            },
          ),
          AppbarTitle(
            text: "Créer Communauté".tr,
            margin: EdgeInsets.only(
              left: 50.h,
              top: 2.v,
              right: 60.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildCreateCommunity(BuildContext context) {
    return Selector<CrErCommunautProvider, TextEditingController?>(
      selector: (context, provider) => provider.createCommunityController,
      builder: (context, createCommunityController, child) {
        return CustomTextFormField(
          controller: createCommunityController,
          hintText: "msg_cr_er_le_nom_de".tr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Le nom de la communauté est requis.";
            }
            return null;
          },
          suffix: Container(
            padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
            child: Icon(Icons.people),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionValue(BuildContext context) {
    return Selector<CrErCommunautProvider, TextEditingController?>(
      selector: (context, provider) => provider.descriptionValueController,
      builder: (context, descriptionValueController, child) {
        return CustomTextFormField(
          controller: descriptionValueController,
          hintText: "lbl_description".tr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "La description est requise.";
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildWebUrl(BuildContext context) {
    return Selector<CrErCommunautProvider, TextEditingController?>(
      selector: (context, provider) => provider.webUrlController,
      builder: (context, webUrlController, child) {
        return Stack(
          children: [
            CustomTextFormField(
              controller: webUrlController,
              hintText: "selectionner images".tr,
              textInputAction: TextInputAction.done,
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () async {
                  // Image picking logic...
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                  child: Icon(Icons.add_photo_alternate),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        text: "lbl_cr_er".tr,
        height: 36.v,
        width: 117.h,
        margin: EdgeInsets.only(right: 12.h),
        buttonTextStyle: CustomTextStyles.labelLargeWhiteA700,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Provider.of<CrErCommunautProvider>(context, listen: false)
                .createCommunity(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 36.v,
        width: 117.h,
        text: "lbl_annuler".tr,
        margin: EdgeInsets.only(left: 12.h),
        buttonStyle: CustomButtonStyles.fillBlueGray,
        buttonTextStyle: theme.textTheme.labelLarge!,
        onPressed: () {
          onTapImage(context);
        },
      ),
    );
  }

  void onTapImage(BuildContext context) {
    NavigatorService.goBack();
  }
}
