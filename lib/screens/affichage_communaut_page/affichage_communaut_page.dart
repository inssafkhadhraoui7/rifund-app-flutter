import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/widgets/app_bar/appbar_title.dart';
import 'package:rifund/widgets/app_bar/custom_app_bar.dart';

class AffichageCommunautPage extends StatefulWidget {
  final String communityId;
  final String projectId;
  final String userId;

  const AffichageCommunautPage(
      {super.key,
      required this.userId,
      required this.projectId,
      required this.communityId});

  @override
  AffichageCommunautPageState createState() => AffichageCommunautPageState();
  static Widget builder(
    BuildContext context, {
    required String userId,
    required String projectId,
    required String communityId,
  }) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = AffichageCommunautProvider();

        provider.setup(userId, projectId, communityId);
        return provider;
      },
      child: AffichageCommunautPage(
        userId: userId,
        projectId: projectId,
        communityId: communityId,
      ),
    );
  }
}

class AffichageCommunautPageState extends State<AffichageCommunautPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider =
          Provider.of<AffichageCommunautProvider>(context, listen: false);
      provider.fetchCommunityDetails();
    });
  }

    Future<void> quitCommunity() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;



    try {
      // Reference to the "membres" collection in Firestore
      final communityRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('projects')
          .doc(widget.projectId)
          .collection('communities')
          .doc(widget.communityId)
          .collection('members');

      await communityRef.doc(currentUserUid).delete();


      log('User successfully removed from the community');
    } finally {
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: Consumer<AffichageCommunautProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.hasError) {
              return Center(child: Text(provider.errorMessage));
            } else {
              return Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 20.v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: provider.communityImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                provider.communityImage,
                                height: 200.v,
                                width: 250.h,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Placeholder(
                              fallbackHeight: 100.v,
                              fallbackWidth: 150.h,
                            ),
                    ),
                    SizedBox(height: 5.v),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 36.h),
                        child: Text(
                          provider.creationDate,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 28.h),
                      child: Text(
                        "lbl_a_propos".tr,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(height: 4.v),
                    Padding(
                      padding: EdgeInsets.only(left: 28.h),
                      child: Text(
                        provider.communityDescription,
                        style: CustomTextStyles.titleLargeLight,
                      ),
                    ),
                    SizedBox(height: 13.v),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Voulez-vous quitter cette communauté?"),
                                content: const Text(
                                    "Êtes-vous sûr de vouloir quitter cette communauté?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Annuler"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Quitter"),
                                    onPressed: () async {
                                      await quitCommunity();

                                      // Ensure context is still valid before popping dialogs
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        NavigatorService.pushNamedAndRemoveUntil(RoutePath.mainPage);

                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
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
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarTitle(
            text: "Communauté details".tr,
            margin: EdgeInsets.only(
              left: 50.h,
              top: 2.v,
              right: 40.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
