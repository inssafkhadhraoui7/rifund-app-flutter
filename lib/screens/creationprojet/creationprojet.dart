import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rifund/screens/listeprojets/listeprojets.dart';

import '../../core/app_export.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../se_connecter_screen/se_connecter_screen.dart';
import 'models/modelcrprojet.dart';

class CrErProjetScreen extends StatefulWidget {
  const CrErProjetScreen({super.key});

  @override
  CrErProjetScreenState createState() => CrErProjetScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CrErProjetProvider(),
      child: const CrErProjetScreen(),
    );
  }
}

class CrErProjetScreenState extends State<CrErProjetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    context.read<CrErProjetProvider>().fetchCategories();
  }

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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: AppbarTitle(
        text: "Créer projet".tr,
        margin: EdgeInsets.only(left: 85.h, top: 2.v, right: 79.h),
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                    readOnly: true,
                    validator: (value) {
                      if (!context
                          .read<CrErProjetProvider>()
                          .isImageSelectionValid()) {
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
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true,
                        );

                        if (result != null) {
                          List<String> paths =
                              result.paths.map((path) => path!).toList();
                          List<String> names =
                              result.files.map((file) => file.name).toList();
                          context
                              .read<CrErProjetProvider>()
                              .updateSelectedImages(paths, names);

                          projectImagesController!.text = names.join(', ');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.v, horizontal: 10.h),
                        child: const Icon(Icons.add_photo_alternate),
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
            validator: validateBudget,
          );
        },
      ),
    );
  }

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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                alignment: Alignment.center,
                items: crErProjetModelObj?.dropdownItemList ?? [],
                onChanged: (value) {
                  // ignore: unnecessary_null_comparison
                  if (value != null) {
                    Provider.of<CrErProjetProvider>(context, listen: false)
                        .onSelectedDropdownItem(value);
                  }
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                validator: validateDate,
                readOnly: true,
              ),
              Positioned(
                right: 10,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (pickedDate != null) {
                      dateController!.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
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
      child: Selector<CrErProjetProvider, List<SelectionPopupModel>>(
        selector: (context, provider) => provider.categoryDropdownItemList,
        builder: (context, categoryList, child) {
          return CustomDropDown(
            icon: Container(
              child: CustomImageView(
                imagePath: ImageConstant.imgcrprojet,
                height: 15.adaptSize,
                width: 15.adaptSize,
              ),
            ),
            hintText: "lbl_cat_gorie".tr,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
            items: categoryList, // Passing List<SelectionPopupModel> here
            onChanged: (SelectionPopupModel? value) {
              if (value != null) {
                context
                    .read<CrErProjetProvider>()
                    .updateSelectedCategory(value.title);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildCompte(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Selector<CrErProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.compteController,
        builder: (context, compteController, child) {
          return CustomTextFormField(
            controller: compteController,
            hintText: "Numero de compte".tr,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
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
        String currency = provider.selectedCurrency;
        DateTime date =
            DateFormat('dd/MM/yyyy').parse(provider.dateController.text);
        String accountNumber = provider.compteController.text;
        double percentage = provider.crErProjetModelObj.percentage;
        List<String> imageUrls = await provider.uploadImages(imagePaths);

        // Add project data to Firestore under the authenticated user's ID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .add({
          "userId": userId,
          'title': title,
          'description': description,
          'images': imageUrls,
          'budget': budget,
          'currency': currency,
          'date': date,
          'percentage': percentage,
          'accountNumber': accountNumber,
          'category': provider.selectedCategory,
          'isApproved': false,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListeDesProjetsPage()),
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
          title: const Text('Connexion requise'),
          content: const Text('Vous devez être connecté pour créer un projet.'),
          actions: [
            TextButton(
              child: const Text('Se connecter'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SeConnecterScreen()),
                );
              },
            ),
            TextButton(
              child: const Text('Annuler'),
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

    if (value.contains('-')) {
      return 'Le budget ne peut pas être un nombre négatif';
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null || value.length < 3) {
      return 'Un montant de 3 chiffres est requis';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La date est requise';
    }
    DateTime? enteredDate = DateFormat('dd/MM/yyyy').tryParse(value);
    if (enteredDate == null) {
      return 'Format de date invalide. Utilisez un format comme dd/MM/yyyy.';
    }
    if (enteredDate.isBefore(DateTime.now().add(const Duration(days: 15)))) {
      return 'La date doit être au moins 15 jours après aujourd\'hui.';
    }
    return null;
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de compte est requis';
    }

    if (double.tryParse(value) == null ||
        value.length < 12 ||
        value.length > 16) {
      return 'Le numéro de compte doit contenir entre 12 et 16 chiffres';
    }

    return null;
  }
}
