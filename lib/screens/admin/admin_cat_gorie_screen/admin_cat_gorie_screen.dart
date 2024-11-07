import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/ajout_cat_gorie_page/ajout_cat_gorie_page.dart';

import '../../../../widgets/app_bar/appbar_title.dart';
import '../../../core/app_export.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_icon_button.dart';
import 'models/admin_cat_gorie_model.dart';
import 'provider/admin_cat_gorie_provider.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  AdminCatGorieScreenState createState() => AdminCatGorieScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminCategoryProvider(),
      child: const AdminCategoryScreen(),
    );
  }
}

class AdminCatGorieScreenState extends State<AdminCategoryScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AdminCategoryProvider>(context, listen: false);
    provider.fetchCategories();
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
                padding: EdgeInsets.only(left: 23.h, right: 17.h),
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
                              builder: (context) => const AjoutCatGoriePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(19),
                        backgroundColor: Colors.lightGreen.shade600,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AdminCategoryProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                            category: category,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
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
          text: "Gérer catégories".tr,
          margin: EdgeInsets.only(left: 80.h, top: 2.v, right: 79.h),
        ),
      ],
    ),
    styleType: Style.bgFill_1,
  );
}

Widget _buildField1(BuildContext context,
    {required AdminCategoryModel category}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
    decoration: AppDecoration.outlineLightgreen600.copyWith(
      borderRadius: BorderRadiusStyle.roundedBorder20,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 9.0),
          child: Image.network(
            category.imageUrl ?? '',
            height: 24.0,
            width: 24.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8.0),
        Padding(
          padding: const EdgeInsets.only(top: 7.0, bottom: 9.0),
          child: Text(
            category.name,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: appTheme.black900,
            ),
          ),
        ),
        const Spacer(),
        CustomIconButton(
          height: 32.0,
          width: 32.0,
          onTap: () {
            _showUpdateDialog(context, category); // Pass the whole category
          },
          child: const Icon(Icons.edit),
        ),
        const SizedBox(width: 8.0),
        CustomIconButton(
          height: 32.0,
          width: 32.0,
          onTap: () {
            deletedialog(context, category.id, category.imageUrl!);
          },
          child: const Icon(Icons.delete),
        ),
      ],
    ),
  );
}

void onTapArrowleftone(BuildContext context) {
  NavigatorService.goBack();
}

void _showUpdateDialog(BuildContext context, AdminCategoryModel category) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController =
      TextEditingController(text: category.name);
  String? newImageUrl;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Modifier Catégorie"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Nom de la catégorie"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    String path = result.files.single.path!;
                    newImageUrl = await uploadImage(path);

                    if (newImageUrl == null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Échec du téléchargement de l'image")),
                      );
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Image sélectionnée")),
                      );
                    }
                  }
                },
                child: const Text("Choisir une image"),
              ),
              if (newImageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                      "Image sélectionnée: ${newImageUrl!.split('/').last}"),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String finalImageUrl = newImageUrl ?? category.imageUrl ?? '';

                Provider.of<AdminCategoryProvider>(context, listen: false)
                    .updateCategory(
                  category.id,
                  nameController.text,
                  finalImageUrl,
                  category.imageUrl,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text("Valider"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}

Future<String?> uploadImage(String path) async {
  final storage = FirebaseStorage.instance;

  File file = File(path);
  try {
    TaskSnapshot snapshot = await storage
        .ref('categories/${file.uri.pathSegments.last}')
        .putFile(file);

    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    log("Erreur de telechargement image: $e");
    return null;
  }
}

void deletedialog(BuildContext context, String categoryId, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Voulez-vous supprimer cette catégorie?"),
        actions: [
          TextButton(
            onPressed: () async {
              final provider =
                  Provider.of<AdminCategoryProvider>(context, listen: false);
              await provider.deleteCategory(categoryId, imageUrl);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text("Oui"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}
