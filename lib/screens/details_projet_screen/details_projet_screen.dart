import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/screens/financer_projet_screen/financer_projet_screen.dart';
import 'package:rifund/widgets/app_bar/appbar_subtitle.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rifund/screens/cr_er_communaut_screen/cr_er_communaut_screen.dart';
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
  final String projectTitle;
  const DetailsProjetScreen({Key? key, required this.projectTitle})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(
                      left: 31.h,
                      right: 23.h,
                    ),
                    child:
                        Selector<DetailsProjetProvider, TextEditingController?>(
                      selector: (context, provider) =>
                          provider.searchController,
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
                _buildSlider(context),
                SizedBox(height: 10.v),
                _buildProjectDetails(context),
                SizedBox(height: 5.v)
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarSubtitle(
            text: "lbl_details_projet".tr,
            margin: EdgeInsets.only(
              left: 80.h,
              top: 2.v,
              right: 79.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  /// Section Widget
  Widget _buildSlider(BuildContext context) {
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
                itemCount: provider.detailsProjetModelObj.sliderItemList.length,
                itemBuilder: (context, index, realIndex) {
                  SliderItemModel model =
                      provider.detailsProjetModelObj.sliderItemList[index];
                  return SliderItemWidget(
                    model,
                  );
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
                  count: provider.detailsProjetModelObj.sliderItemList.length,
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
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProjectDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 19.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_dur_e_1_mois".tr,
            style: theme.textTheme.titleSmall,
          ),
         
          SizedBox(height: 1.v),
<<<<<<< HEAD
        Padding(
  padding: EdgeInsets.only(right: 8.h),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded( // Wrap with Expanded to avoid overflow
        child: Padding(
          padding: EdgeInsets.only(top: 3.v),
          child: Text(
            "msg_communaut_de_camping".tr,
            style: CustomTextStyles.titleLargeInterExtraBold,
=======
          Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.v),
                  child: Text(
                    widget.projectTitle,
                    style: CustomTextStyles.titleLargeInterExtraBold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.group),
                  iconSize: 30.0,
                  tooltip: 'Rejoindre Communauté',
                  padding: EdgeInsets.only(
                    left: 28.h,
                    bottom: 3.v,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text(
                              'Vous-etes sure pour rejoindre cette communauté?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Rejoindre Communauté'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatBoxScreen()),
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
                  },
                ),
              ],
            ),
>>>>>>> ahmed
          ),
        ),
      ),
IconButton(
  icon: Icon(Icons.group),
  iconSize: 30.0,
  tooltip: 'Rejoindre Communauté',
  padding: EdgeInsets.only(
    left: 28.h,
    bottom: 3.v,
  ),
  onPressed: () async {
    try {
      // Get the current logged-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Show a message if the user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to join the community')),
        );
        return;
      }

      String currentUserId = user.uid; // Firebase user ID
      String communityId = 'some_community_id'; // Replace with actual community ID logic

      // Fetch current user's details from 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userSnapshot.exists) {
        String userId = userSnapshot.id; // User ID
        String userName = userSnapshot['name']; // User's name

        // Check if the user is already a participant
        DocumentSnapshot participantDoc = await FirebaseFirestore.instance
            .collection('communities')
            .doc(communityId)
            .collection('participants')
            .doc(userId)
            .get();

        if (participantDoc.exists) {
          // User is already a participant, navigate directly to the chat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBoxScreen()),
          );
        } else {
          // Show confirmation dialog if user is not a participant
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Voulez-vous rejoindre cette communauté ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Rejoindre Communauté'),
                    onPressed: () async {
                      // Add user as a participant in Firestore
                      await FirebaseFirestore.instance
                          .collection('communities')
                          .doc(communityId)
                          .collection('participants')
                          .doc(userId)
                          .set({
                        'joinedAt': Timestamp.now(),
                        'userId': userId,
                        'name': userName,
                      });

                      // Navigate to the chat box after adding the user as a participant
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatBoxScreen()),
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // If user document is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found. Please try again.')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue: $e')),
      );
    }
  },
      ),
     
    ],
  ),
),

          SizedBox(height: 9.v),
          Padding(
            padding: EdgeInsets.only(right: 30.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "msg_contributions".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 10.v),
                    Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Text(
                        "lbl_80_000".tr,
                        style: CustomTextStyles.titleLargeInterOnPrimary,
                      ),
                    ),
                    SizedBox(height: 11.v),
                    Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Text(
                        "lbl_96_000".tr,
                        style: CustomTextStyles.titleLargeInterPrimary,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 146.h,
                  margin: EdgeInsets.only(
                    left: 25.h,
                    top: 2.v,
                  ),
                  child: Text(
                    "msg_en_r_sum_le_camping".tr,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(
                      height: 1.40,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 18.v),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 285.h,
              padding: EdgeInsets.symmetric(
                horizontal: 9.h,
                vertical: 1.v,
              ),
              decoration: AppDecoration.fillYellow.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder7,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "lbl_120".tr,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
          ),
          SizedBox(height: 19.v),
          CustomElevatedButton(
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
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
