import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/screens/acceuil_client_page/models/listtext_item_model.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/screens/financer_projet_screen/financer_projet_screen.dart';
import 'package:rifund/widgets/app_bar/appbar_subtitle.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/slider_item_model.dart';
import 'widgets/slider_item_widget.dart';

class DetailsProjetScreen extends StatefulWidget {
  final ListtextItemModel project;

  const DetailsProjetScreen({
    super.key,
    required this.project,
  });

  @override
  DetailsProjetScreenState createState() => DetailsProjetScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailsProjetProvider(),
    );
  }
}

class DetailsProjetScreenState extends State<DetailsProjetScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String? communityId;
  String? messageId;
  String? userId;
  String? projectId;
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();

    userId = widget.project.userId;
    projectId = widget.project.id;

    if (userId != null && projectId != null) {
      fetchCommunityId(userId!, projectId!);
    }
  }

  Future<void> fetchCommunityId(String userId, String projectId) async {
    log("userId: $userId, projectId: $projectId");

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .get();

      log("Number of communities found: ${snapshot.docs.length}");
      if (snapshot.docs.isNotEmpty) {
        final firstCommunityId = snapshot.docs.first.id;
        setState(() {
          communityId = firstCommunityId;
        });
        log("Community ID fetched: $communityId");
        await fetchChatMessages(communityId!);
      } else {
        log("No communities found for userId: $userId and projectId: $projectId");
        // If no community found, create a new one
        await createNewCommunity(userId, projectId);
      }
    } catch (e) {
      log("Error fetching community ID: $e");
    }
  }

  Future<void> createNewCommunity(String userId, String projectId) async {
    try {
      // Create a new community document
      DocumentReference communityRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .add({
        'name': 'New Community', // Default name, can be changed later
        'timestamp': FieldValue.serverTimestamp(),
      });

      log("New community created with ID: ${communityRef.id}");

      // After creating the community, fetch the messages
      setState(() {
        communityId = communityRef.id;
      });

      // Optionally, you can fetch the chat messages for the newly created community
      await fetchChatMessages(communityRef.id);
    } catch (e) {
      log("Error creating new community: $e");
    }
  }

  Future<void> fetchChatMessages(String communityId) async {
    try {
      final messageSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId)
          .collection('chat_messages')
          .get();

      setState(() {
        chatMessages = messageSnapshot.docs.map((doc) {
          return {
            'messageId': doc.id,
            'sender': doc['userName'],
            'text': doc['message'],
            'timestamp': doc['timestamp'],
          };
        }).toList();

        messageId =
            chatMessages.isNotEmpty ? chatMessages[0]['messageId'] : null;
      });
      log("Chat messages fetched: $chatMessages");
    } catch (e) {
      log("Error fetching chat messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SliderItemModel> sliderItems = widget.project.images != null
        ? widget.project.images!
            .map((image) => SliderItemModel(
                imageUrl: image,
                title: widget.project.title ?? "Project",
                description: widget.project.description ?? "No Description",
                budget: widget.project.budget ?? 0.0))
            .toList()
        : [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 23.h),
                //     child:
                //         Selector<DetailsProjetProvider, TextEditingController?>(
                //       selector: (context, provider) =>
                //           provider.searchController,
                //       builder: (context, searchController, child) {
                //         return CustomSearchView(
                //           controller: searchController,
                //           hintText: "lbl_rechercher".tr,
                //           alignment: Alignment.center,
                //         );
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(height: 10.v),
                _buildSlider(context, sliderItems),
                SizedBox(height: 10.v),
                _buildProjectDetails(context),
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
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => NavigatorService.goBack(),
          ),
          AppbarSubtitle(
            text: "lbl_details_projet".tr,
            margin: EdgeInsets.only(left: 80.h, top: 2.v, right: 79.h),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildSlider(BuildContext context, List<SliderItemModel> sliderItems) {
    return Padding(
      padding: EdgeInsets.only(left: 19.h),
      child: Column(
        children: [
          Consumer<DetailsProjetProvider>(
            builder: (context, provider, child) {
              return CarouselSlider.builder(
                options: CarouselOptions(
                  height: 220.v,
                  initialPage: 0,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    provider.sliderIndex = index;
                  },
                ),
                itemCount: sliderItems.length,
                itemBuilder: (context, index, realIndex) {
                  return sliderItems.isNotEmpty
                      ? SliderItemWidget(sliderItems[index])
                      : const Center(child: Text("No images available"));
                },
              );
            },
          ),
          SizedBox(height: 11.v),
          Consumer<DetailsProjetProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                height: 4.v,
                child: AnimatedSmoothIndicator(
                  activeIndex: provider.sliderIndex,
                  count: sliderItems.length,
                  axisDirection: Axis.horizontal,
                  effect: ScrollingDotsEffect(
                    spacing: 4,
                    activeDotColor: appTheme.black900,
                    dotColor: appTheme.blueGray100,
                    dotHeight: 4.v,
                    dotWidth: 4.h,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 19.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.v),
              child: Text(
                widget.project.title ?? "Project Title",
                style: CustomTextStyles.titleLargeInterExtraBold,
              ),
            ),
          ),
          SizedBox(height: 1.v),
          Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.v),
                  child: Text(
                    "Cliquer sur l'icone pour rejoindre ", // Updated text
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  iconSize: 30.0,
                  tooltip: 'Rejoindre Communauté',
                  padding: EdgeInsets.only(left: 10.h, bottom: 3.v),
                  onPressed: () => _showJoinCommunityDialog(),
                ),
              ],
            ),
          ),
          SizedBox(height: 9.v),
          _buildContributionDetails(context),
          SizedBox(height: 18.v),
          _buildDonationButton(context),
        ],
      ),
    );
  }

  Widget _buildContributionDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 30.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("msg_contributions".tr, style: theme.textTheme.titleSmall),
              SizedBox(height: 21.v),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
               child: Text("TND ${widget.project.budget.toString()}",
                    style: CustomTextStyles.titleLargeInterPrimary),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 80.h, top: 2.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description:",
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 4.v),
                  Text(
                    widget.project.description ?? "No Description",
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomElevatedButton(
        height: 50.v,
        width: 208.h,
        text: "lbl_faire_un_don".tr,
        buttonStyle: CustomButtonStyles.fillPrimary,
        buttonTextStyle: theme.textTheme.titleMedium!,
        alignment: Alignment.center,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FinancerProjetScreen()),
          );
        },
      ),
    );
  }

  void _showJoinCommunityDialog() {
    if (communityId == null || userId == null || projectId == null) {
      log("Missing required fields for joining community.");
      return;
    }
Future<Map<String, String>> getUserData() async {
  try {
    // Get the current user's UID from Firebase Auth
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      log("No user is currently signed in");
      return {'nom': 'Unknown', 'image': ''};
    }

    // Fetch the user's document from Firestore using the UID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      // Retrieve nom and image fields, defaulting to empty strings if not found
      String nom = userDoc['nom'] ?? 'Unknown';
      String image = userDoc['image_user'] ?? '';
      return {'nom': nom, 'image': image};
    } else {
      log("User document does not exist");
      return {'nom': 'Unknown', 'image': ''};
    }
  } catch (e) {
    log("Error fetching user data: $e");
    return {'nom': 'Unknown', 'image': ''};
  }
}
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Rejoindre la communauté"),
          content: const Text("Souhaitez-vous rejoindre cette communauté ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
  onPressed: () async {
    if (communityId == null) {
      // Display an alert dialog to inform the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Avis"),
            content: const Text("Ce projet n'a pas de communauté."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else if (userId != null && projectId != null) {
      try {
        log("Joining community with ID: $communityId");
        Map<String, String> userData = await getUserData();

        // Add user to community members
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .doc(projectId)
            .collection('communities')
            .doc(communityId)
            .collection('members')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'joinedAt': Timestamp.now(),
          'nom': userData['nom'],
          'image': userData['image'],
          'status': 'En attend',
        });

        if (!context.mounted) return;

        Navigator.of(context).pop();
        log("userId: $userId , projectId: $projectId, communityId: $communityId");

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBoxScreen.builder(
              context,
              userId: userId ?? '',
              projectId: projectId ?? '',
              communityId: communityId!,
            ),
          ),
        );
      } catch (e) {
        log("Error joining community: $e");
      }
    } else {
      log("One or more required fields are empty");
    }
  },
  child: const Text("Rejoindre"),
),

          ],
        );
      },
    );
  }
}
