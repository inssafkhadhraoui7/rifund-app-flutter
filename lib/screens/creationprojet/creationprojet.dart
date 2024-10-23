import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rifund/screens/listeprojets/listeprojets.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../se_connecter_screen/se_connecter_screen.dart';
import 'models/modelcrprojet.dart';
import 'provider/cr_er_projet_provider.dart';

class CrErProjetScreen extends StatefulWidget {
  const CrErProjetScreen({Key? key}) : super(key: key);

  @override
  CrErProjetScreenState createState() => CrErProjetScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CrErProjetProvider(),
      child: CrErProjetScreen(),
    );
  }
}

class CrErProjetScreenState extends State<CrErProjetScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
<<<<<<< HEAD

=======
  String selectedCurrency = 'TND';
  String selectedCategory = '';
>>>>>>> ahmed
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 27.h, vertical: 16.v),
              child: Column(
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.h),
                      child: Text(
                        "msg_creation_du_projet".tr,
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.v),
                  Text(
                    "msg_cr_er_votre_projet".tr,
                    style: CustomTextStyles.titleLargeInterSemiBold,
                  ),
                  SizedBox(height: 18.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: Text(
                        "msg_remplir_la_formulaire".tr,
                        style: CustomTextStyles.bodyMediumBlack900,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.v),
                  _buildProjectTitle(context),
                  SizedBox(height: 18.v),
                  _buildDescriptionValue(context),
                  SizedBox(height: 18.v),
                  _buildProjectImages(context),
                  SizedBox(height: 18.v),
                  _buildDeviseValue(context),
                  SizedBox(height: 18.v),
                  _buildDate(context),
                  SizedBox(height: 18.v),
                  _buildCategoryDropdown(context),
                  SizedBox(height: 18.v),
                  _buildCompte(context),
                  SizedBox(height: 18.v),
                  _buildCreateButton(context),
                ],
              ),
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
            onPressed: () => Navigator.pop(context),
          ),
          AppbarTitle(
            text: "Créer projet".tr,
            margin: EdgeInsets.only(left: 85.h, top: 2.v, right: 79.h),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildProjectTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.projectTitleController,
        builder: (context, projectTitleController, child) {
          return CustomTextFormField(
            controller: projectTitleController,
            hintText: "lbl_titre_du_projet".tr,
<<<<<<< HEAD
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
=======
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
>>>>>>> ahmed
            validator: validateProjectTitle,
          );
        },
      ),
    );
  }

  Widget _buildDescriptionValue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.descriptionValueController,
        builder: (context, descriptionValueController, child) {
          return CustomTextFormField(
            controller: descriptionValueController,
            hintText: "lbl_description".tr,
<<<<<<< HEAD
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
=======
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
>>>>>>> ahmed
            validator: validateDescription,
          );
        },
      ),
    );
  }

  Widget _buildProjectImages(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.projectImagesController,
        builder: (context, projectImagesController, child) {
          return Column(
            children: [
              Stack(
                children: [
                  CustomTextFormField(
                    controller: projectImagesController,
                    hintText: "msg_images_du_projet".tr,
<<<<<<< HEAD
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                    readOnly: true,
                    validator: (value) {
                      if (!context.read<CrErProjetProvider>().isImageSelectionValid()) {
=======
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                    readOnly: true,
                    validator: (value) {
                      if (!context
                          .read<CrErProjetProvider>()
                          .isImageSelectionValid()) {
>>>>>>> ahmed
                        return 'Veuillez sélectionner entre 1 et 5 images.';
                      }
                      return null;
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () async {
<<<<<<< HEAD
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
=======
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
>>>>>>> ahmed
                          type: FileType.image,
                          allowMultiple: true,
                        );

                        if (result != null) {
<<<<<<< HEAD
                          List<String> paths = result.paths.map((path) => path!).toList();
                          List<String> names = result.files.map((file) => file.name ?? '').toList();

                          context.read<CrErProjetProvider>().updateSelectedImages(paths, names);
=======
                          List<String> paths =
                              result.paths.map((path) => path!).toList();
                          List<String> names = result.files
                              .map((file) => file.name ?? '')
                              .toList();

                          context
                              .read<CrErProjetProvider>()
                              .updateSelectedImages(paths, names);
>>>>>>> ahmed

                          projectImagesController!.text = names.join(', ');
                        }
                      },
                      child: Container(
<<<<<<< HEAD
                        padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
=======
                        padding: EdgeInsets.symmetric(
                            vertical: 8.v, horizontal: 10.h),
>>>>>>> ahmed
                        child: Icon(Icons.add_photo_alternate),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.v),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBudgetValue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.budgetValueController,
        builder: (context, budgetValueController, child) {
          return CustomTextFormField(
            width: 143.h,
            controller: budgetValueController,
            hintText: "lbl_budget".tr,
<<<<<<< HEAD
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
=======
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
>>>>>>> ahmed
            validator: validateBudget,
          );
        },
      ),
    );
  }

  String selectedCurrency = 'TND'; // Default currency
  Widget _buildDeviseValue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBudgetValue(context),
          Selector<CrErProjetProvider, CrErProjetModel?>(
            selector: (context, provider) => provider.crErProjetModelObj,
            builder: (context, crErProjetModelObj, child) {
              return CustomDropDown(
                width: 116.h,
                icon: CustomImageView(
                  imagePath: ImageConstant.imgcrprojet,
                  height: 15.adaptSize,
                  width: 10.adaptSize,
                ),
                hintText: "lbl_devise".tr,
<<<<<<< HEAD
                contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                alignment: Alignment.center,
                items: crErProjetModelObj?.dropdownItemList ?? [],
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value as String; // Update the selected currency
                  });
=======
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                alignment: Alignment.center,
                items: crErProjetModelObj?.dropdownItemList ?? [],
                onChanged: (value) {
                  if (value != null) {
                    Provider.of<CrErProjetProvider>(context, listen: false)
                        .onSelectedDropdownItem(value);
                  }
>>>>>>> ahmed
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.dateController,
        builder: (context, dateController, child) {
          return Stack(
            children: [
              CustomTextFormField(
                controller: dateController,
                hintText: "lbl_date".tr,
<<<<<<< HEAD
                contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
=======
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
>>>>>>> ahmed
                validator: validateDate,
                readOnly: true,
              ),
              Positioned(
                right: 10,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (pickedDate != null) {
<<<<<<< HEAD
                      dateController!.text = DateFormat('dd/MM/yyyy').format(pickedDate);
=======
                      dateController!.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
>>>>>>> ahmed
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
<<<<<<< HEAD
      child: Selector<CrErProjetProvider, CrErProjetModel?>(
=======
      child: Selector<CrErProjetProvider, CrErProjetModel>(
>>>>>>> ahmed
        selector: (context, provider) => provider.crErProjetModelObj,
        builder: (context, crErProjetModelObj, child) {
          return CustomDropDown(
            icon: Container(
              child: CustomImageView(
                imagePath: ImageConstant.imgcrprojet,
                height: 15.adaptSize,
                width: 15.adaptSize,
              ),
            ),
            hintText: "lbl_cat_gorie".tr,
<<<<<<< HEAD
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
            items: crErProjetModelObj?.categoryDropdownItemList ?? [],
=======
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
            items: crErProjetModelObj.categoryDropdownItemList,
            onChanged: (value) {
              // Call the provider method to update the selected category
              if (value != null) {
                Provider.of<CrErProjetProvider>(context, listen: false)
                    .onSelectedCategoryItem(value);
                Provider.of<CrErProjetProvider>(context, listen: false)
                    .updateSelectedCategory(value.title);
              }
            },
>>>>>>> ahmed
          );
        },
      ),
    );
  }

  Widget _buildCompte(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.compteController,
        builder: (context, compteController, child) {
          return CustomTextFormField(
            controller: compteController,
            hintText: "Numero de compte".tr,
<<<<<<< HEAD
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
=======
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
>>>>>>> ahmed
            validator: validateAccountNumber,
          );
        },
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Consumer<CrErProjetProvider>(builder: (context, provider, child) {
      return CustomElevatedButton(
        height: 36.v,
        width: 114.h,
        text: _isLoading ? 'Loading...' : "lbl_cr_er".tr,
        buttonTextStyle: CustomTextStyles.titleLargeInterOnPrimaryContainer,
        onPressed: _isLoading ? null : () => _handleCreateProject(provider),
      );
    });
  }

  Future<void> _handleCreateProject(CrErProjetProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        // Show notification
        _showLoginDialog();
        return;
      }

      setState(() => _isLoading = true);
      try {
        String title = provider.projectTitleController.text;
        String description = provider.descriptionValueController.text;
        List<String> imagePaths = provider.selectedImagePaths;
        double budget = double.parse(provider.budgetValueController.text);
        String currency = selectedCurrency;
<<<<<<< HEAD
        DateTime date = DateFormat('dd/MM/yyyy').parse(provider.dateController.text);
        String accountNumber = provider.compteController.text;

=======
        DateTime date =
            DateFormat('dd/MM/yyyy').parse(provider.dateController.text);
        String accountNumber = provider.compteController.text;
        double percentage = provider.crErProjetModelObj.percentage;
>>>>>>> ahmed
        List<String> imageUrls = await provider.uploadImages(imagePaths);

        // Add project data to Firestore under the authenticated user's ID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .add({
          'title': title,
          'description': description,
          'images': imageUrls,
          'budget': budget,
          'currency': currency,
          'date': date,
<<<<<<< HEAD
          'accountNumber': accountNumber,
=======
          'percentage': percentage,
          'accountNumber': accountNumber,
          'category': selectedCategory,
>>>>>>> ahmed
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListeDesProjetsPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connexion requise'),
          content: Text('Vous devez être connecté pour créer un projet.'),
          actions: [
            TextButton(
              child: Text('Se connecter'),
              onPressed: () {
                Navigator.push(
                  context,
<<<<<<< HEAD
                  MaterialPageRoute(builder: (context) => const SeConnecterScreen()),
=======
                  MaterialPageRoute(
                      builder: (context) => const SeConnecterScreen()),
>>>>>>> ahmed
                );
              },
            ),
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Validators

  String? validateProjectTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Il faut remplir cet champs';
    }
    if (value.length < 5 || value.length > 50) {
      return 'Le titre du projet doit contenir au moins 5 caractères et au plus 50';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La description est requise';
    }
    if (value.length < 10 || value.length > 100) {
      return 'La description doit contenir au moins 10 caractères et au plus 100';
    }
    return null;
  }

  String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le budget est requis';
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null || value.length < 3) {
      return 'un montant de 3 numéro';
    }

    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La date est requise';
    }
<<<<<<< HEAD
    DateTime? enteredDate = DateFormat('dd/MM/yyyy').parse(value);
=======
    DateTime? enteredDate = DateFormat('dd/MM/yyyy').tryParse(value);
>>>>>>> ahmed
    if (enteredDate == null) {
      return 'Format de date invalide. Utilisez un format comme dd/MM/yyyy.';
    }
    if (enteredDate.isBefore(DateTime.now().add(Duration(days: 15)))) {
      return 'La date doit être au moins 15 jours après aujourd\'hui.';
    }
    return null;
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de compte est requis';
    }

<<<<<<< HEAD
    if (double.tryParse(value) == null || value.length < 12 || value.length > 16) {
=======
    if (double.tryParse(value) == null ||
        value.length < 12 ||
        value.length > 16) {
>>>>>>> ahmed
      return 'Le numéro de compte doit contenir entre 12 et 16 chiffres';
    }

    return null;
  }
}