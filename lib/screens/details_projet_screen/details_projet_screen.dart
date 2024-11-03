import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/main.dart';
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
import '../../widgets/custom_search_view.dart';
import 'models/slider_item_model.dart';
import 'provider/details_projet_provider.dart';
import 'widgets/slider_item_widget.dart';

class DetailsProjetScreen extends StatefulWidget {
  final ListtextItemModel project;

  const DetailsProjetScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

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
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    fetchUserAndProjectData();
  }

  Future<void> fetchUserAndProjectData() async {
    try {
      // Fetch userId and projectId based on project name and description
      final userId = await fetchUserIdByProjectDetails(widget.project.title, widget.project.description);
      final projectId = await fetchProjectIdByDetails(widget.project.title, widget.project.description);

      // Check if the IDs are available
      if (userId != null && projectId != null) {
        await fetchCommunityId(userId, projectId);
      } else {
        print("User ID or Project ID is null.");
      }
    } catch (e) {
      print("Error fetching user and project data: $e");
    }
  }

  Future<String?> fetchUserIdByProjectDetails(String? title, String? description) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects') // Replace with your collection
          .where('title', isEqualTo: title)
          .where('description', isEqualTo: description)
          .limit(1) // Only fetch the first match
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['userId']; // Ensure the field exists
      }
    } catch (e) {
      print("Error fetching userId: $e");
    }
    return null;
  }

  Future<String?> fetchProjectIdByDetails(String? name, String? description) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects') // Replace with your collection
          .where('title', isEqualTo: name)
          .where('description', isEqualTo: description)
          .limit(1) // Only fetch the first match
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id; // Getting document ID
      }
    } catch (e) {
      print("Error fetching projectId: $e");
    }
    return null;
  }

  Future<void> fetchCommunityId(String userId, String projectId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          communityId = snapshot.docs.first.id;
        });
        print("Community ID fetched: $communityId");
        await fetchChatMessages(communityId!);
      } else {
        print("No communities found for userId: $userId and projectId: $projectId");
      }
    } catch (e) {
      print("Error fetching community ID: $e");
    }
  }

  Future<void> fetchChatMessages(String communityId) async {
    try {
      final messageSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.project.userId)
          .collection('projects')
          .doc(widget.project.projectId)
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

        messageId = chatMessages.isNotEmpty ? chatMessages[0]['messageId'] : null;
      });
    } catch (e) {
      print("Error fetching chat messages: $e");
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
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.h),
                    child: Selector<DetailsProjetProvider, TextEditingController?>(
                      selector: (context, provider) => provider.searchController,
                      builder: (context, searchController, child) {
                        return CustomSearchView(
                          controller: searchController,
                          hintText: "lbl_rechercher".tr,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),
                ),
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
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
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
                      : Center(child: Text("No images available"));
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
                  icon: Icon(Icons.group),
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
                child: Text("\$${widget.project.budget.toString()}",
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
            MaterialPageRoute(builder: (context) => FinancerProjetScreen()),
          );
        },
      ),
    );
  }
 void _showJoinCommunityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Join Community"),
          content: Text("Would you like to join this community?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (communityId != null) {
                  // Add user to community logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBoxScreen(
                        communityId: communityId!, userId: userId, projectId:projectId, messageId: messageId,
                      ),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text("Join"),
            ),
          ],
        );
      },
    );
  }

}
