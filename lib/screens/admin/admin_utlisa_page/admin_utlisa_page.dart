import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/models/userprofile_item_model.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/provider/admin_utlisa_provider.dart';
import 'package:rifund/widgets/app_bar/appbar_title.dart';
import 'package:rifund/widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';

class AdminUtlisaPage extends StatefulWidget {
  const AdminUtlisaPage({Key? key}) : super(key: key);

  @override
  AdminUtlisaPageState createState() => AdminUtlisaPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminUtlisaProvider(),
      child: const AdminUtlisaPage(),
    );
  }
}

class AdminUtlisaPageState extends State<AdminUtlisaPage> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminUtlisaProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: FutureBuilder<List<CustomUser>>(
          future: adminProvider.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Erreur lors de la récupération des utilisateurs"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucun utilisateur trouvé"));
            }

            List<CustomUser> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                CustomUser user = users[index];
                return ListTile(
                  title: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.block, color: Colors.red),
                        onPressed: () => adminProvider.blockUser(user.uid, context),
                        tooltip: "Bloquer l'utilisateur",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Confirm deletion
                          bool? confirm = await _showConfirmationDialog(context, "Confirmer la suppression", "Êtes-vous sûr de vouloir supprimer cet utilisateur ?");
                          if (confirm == true) {
                            await adminProvider.deleteUser(user.uid, context);
                            setState(() {}); // Re-fetch users after deletion
                          }
                        },
                        tooltip: "Supprimer un utilisateur",
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => adminProvider.acceptUser(user.uid, context),
                        tooltip: "Accepter l'utilisateur",
                      ),
                    ],
                  ),
                );
              },
            );
          },
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
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppbarTitle(
            text: "Gérer Utilisateurs",
            margin: EdgeInsets.only(left: 80, top: 2, right: 79),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Confirmer"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
