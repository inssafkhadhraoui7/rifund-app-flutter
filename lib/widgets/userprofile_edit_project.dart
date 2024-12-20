import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // for accessing the provider
import 'package:rifund/screens/creationprojet/provider/cr_er_projet_provider.dart';
import 'package:rifund/widgets/custom_text_form_field.dart'; // Assuming your custom widget

class EditProjectDialog extends StatefulWidget {
  final String projectId;

  const EditProjectDialog({Key? key, required this.projectId})
      : super(key: key);

  @override
  _EditProjectDialogState createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  Future<void> _loadProjectData() async {
    await Provider.of<CrErProjetProvider>(context, listen: false)
        .loadUserProjectForEditing(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrErProjetProvider>(context);

    return AlertDialog(
      title: Text("Modifier projet"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildDescriptionField(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildBudgetField(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildDateField(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildAccountNumberField(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildCurrencyDropdown(provider),
              SizedBox(height: 16), // Adding space between fields
              _buildCategoryDropdown(provider),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: _isLoading ? null : () => _updateProject(provider),
          child: _isLoading ? Text("Enregistrer...") : Text("Enregistrer"),
        ),
      ],
    );
  }

  // Title field
  Widget _buildTitleField(CrErProjetProvider provider) {
    return CustomTextFormField(
      controller: provider.projectTitleController,
      hintText: "Titre du projet",
      validator: (value) {
        if (value!.isEmpty) {
          return "Le titre est requis";
        }
        return null;
      },
    );
  }

  // Description field
  Widget _buildDescriptionField(CrErProjetProvider provider) {
    return CustomTextFormField(
      controller: provider.descriptionValueController,
      hintText: "Description",
      validator: (value) {
        if (value!.isEmpty) {
          return "Description est requis";
        }
        return null;
      },
    );
  }

  // Budget field
  Widget _buildBudgetField(CrErProjetProvider provider) {
    return CustomTextFormField(
      controller: provider.budgetValueController,
      hintText: "Budget",
      validator: (value) {
        if (value!.isEmpty) {
          return "Le budget est requis";
        }
        return null;
      },
    );
  }

  // Date field
  Widget _buildDateField(CrErProjetProvider provider) {
    return CustomTextFormField(
      controller: provider.dateController,
      hintText: "Date",
      validator: (value) {
        if (value!.isEmpty) {
          return "la date est requis";
        }
        return null;
      },
    );
  }

  // Account number field
  Widget _buildAccountNumberField(CrErProjetProvider provider) {
    return CustomTextFormField(
      controller: provider.compteController,
      hintText: "Numéro du compte",
      validator: (value) {
        if (value!.isEmpty) {
          return "Le numéro de compte est requis";
        }
        return null;
      },
    );
  }

  // Currency dropdown
  Widget _buildCurrencyDropdown(CrErProjetProvider provider) {
    return DropdownButton<String>(
      value: provider.selectedCurrency,
      onChanged: (String? newValue) {
        provider.selectedCurrency = newValue!;
      },
      items: provider.crErProjetModelObj.dropdownItemList
          .map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item.title,
          child: Text(
            item.title,
            style: TextStyle(color: Colors.black), // Set text color to black
          ),
        );
      }).toList(),
    );
  }

  // Category dropdown
  Widget _buildCategoryDropdown(CrErProjetProvider provider) {
    return FutureBuilder(
      future: provider.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erreur de telechargement des categories');
        }

        return DropdownButton<String>(
          value: provider.selectedCategory.isNotEmpty
              ? provider.selectedCategory
              : null,
          onChanged: (String? newValue) {
            if (newValue != null) {
              provider.updateSelectedCategory(newValue);
            }
          },
          hint: Text('Selectionner Category'),
          style: TextStyle(color: Colors.black), // Set text color to black
          items: provider.categoryDropdownItemList
              .map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item.title,
              child: Text(
                item.title,
                style:
                    TextStyle(color: Colors.black), // Set text color to black
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _updateProject(CrErProjetProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await provider.updateUserProject(widget.projectId);
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating project: $e')),
        );
      }
    }
  }
}
