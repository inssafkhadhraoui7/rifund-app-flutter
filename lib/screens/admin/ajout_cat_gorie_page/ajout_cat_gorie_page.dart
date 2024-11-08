import 'package:file_picker/file_picker.dart';
import 'package:rifund/screens/admin/admin_cat_gorie_screen/admin_cat_gorie_screen.dart';

import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class AjoutCatGoriePage extends StatefulWidget {
  const AjoutCatGoriePage({super.key});

  @override
  AjoutCatGoriePageState createState() => AjoutCatGoriePageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AjoutCatGorieProvider(),
      child: const AjoutCatGoriePage(),
    );
  }
}

class AjoutCatGoriePageState extends State<AjoutCatGoriePage> {
  final _formKey = GlobalKey<FormState>(); // Form key to manage validation

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
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: _formKey, // Wrap form elements with Form widget
            child: Column(
              children: [
                SizedBox(height: 54.v),
                Text("msg_ajouter_cat_gorie".tr,
                    style: TextStyle(
                      color: Colors.lightGreen.shade600,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    )),
                SizedBox(height: 59.v),
                _buildAddCategory(context),
                SizedBox(height: 5.v),
              ],
            ),
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
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarTitle(
            text: "Gérer Catégories".tr,
            margin: EdgeInsets.only(
              left: 60.h,
              top: 2.v,
              right: 79.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildAddCategory(BuildContext context) {
    return Container(
      width: 299.h,
      margin: EdgeInsets.only(right: 9.h),
      padding: EdgeInsets.symmetric(horizontal: 29.h, vertical: 47.v),
      decoration: AppDecoration.outlineLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Selector<AjoutCatGorieProvider, TextEditingController?>(
              selector: (context, provider) => provider.categorynameController,
              builder: (context, categorynameController, child) {
                return CustomTextFormField(
                  controller: categorynameController,
                  hintText: "msg_nom_de_categorie".tr,
                  hintStyle: CustomTextStyles.bodyMediumThin,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    return context
                        .read<AjoutCatGorieProvider>()
                        .validateCategoryName(value);
                  },
                  suffix: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 20.h),
                    child: const Icon(Icons.extension),
                  ),
                  suffixConstraints: BoxConstraints(maxHeight: 50.v),
                  contentPadding:
                      EdgeInsets.only(left: 24.h, top: 17.v, bottom: 17.v),
                  borderDecoration: TextFormFieldStyleHelper.outlineLightGreen,
                  filled: true,
                  fillColor: appTheme.whiteA700,
                );
              },
            ),
          ),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Selector<AjoutCatGorieProvider, List<String>>(
              selector: (context, provider) => provider.imageUrls,
              builder: (context, imageUrls, child) {
                return Column(
                  children: [
                    CustomTextFormField(
                      hintText: "selectionner votre images".tr,
                      hintStyle: CustomTextStyles.bodyMediumThin,
                      readOnly: true,
                      controller: TextEditingController(
                        text: context
                            .watch<AjoutCatGorieProvider>()
                            .selectedImageName,
                      ),
                      suffix: IconButton(
                        icon: const Icon(Icons.add_photo_alternate),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: true,
                          );
                          if (result != null) {
                            List<String> paths =
                                result.paths.map((path) => path!).toList();
                            await context
                                .read<AjoutCatGorieProvider>()
                                .uploadImages(paths);

                            context
                                .read<AjoutCatGorieProvider>()
                                .setSelectedImageName(
                                  result.names.first ?? '',
                                );
                          }
                        },
                      ),
                      suffixConstraints: BoxConstraints(maxHeight: 50.v),
                      contentPadding:
                          EdgeInsets.only(left: 24.h, top: 17.v, bottom: 17.v),
                    ),
                    SizedBox(height: 10.v),
                    if (imageUrls.isNotEmpty)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: imageUrls.map((url) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 40.v),
          Padding(
            padding: EdgeInsets.only(left: 15.h, right: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  width: 104.h,
                  height: 40.v,
                  text: "lbl_valider".tr,
                  buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AjoutCatGorieProvider>().addCategory();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminCategoryScreen()),
                      );
                    }
                  },
                ),
                CustomElevatedButton(
                  width: 104.h,
                  height: 40.v,
                  text: "lbl_annuler".tr,
                  margin: EdgeInsets.only(left: 8.h),
                  buttonStyle: CustomButtonStyles.fillGray,
                  buttonTextStyle: CustomTextStyles.titleSmallBlack900,
                  onPressed: () {
                    onTapArrowleftone(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
