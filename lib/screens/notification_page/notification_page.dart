import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure you import provider

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import 'models/notification_model.dart';
import 'provider/notification_provider.dart'; // ignore_for_file: must_be_immutable

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  NotificationPageState createState() => NotificationPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: const NotificationPage(),
    );
  }
}

class NotificationPageState extends State<NotificationPage> {
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    fetchUserNotifications();
  }

  Future<void> fetchUserNotifications() async {
    String userId = "user_connected_id"; // Replace with actual user ID
    await _notificationProvider.fetchNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.v),
                    Padding(
                      padding: EdgeInsets.only(left: 23.h),
                      child: Text(
                        "lbl_aujourd_hui".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.titleLargeBlack900,
                      ),
                    ),
                    SizedBox(height: 5.v),
                    // Display notifications for today
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(
                            context, provider.notifications[index]);
                      },
                    ),
                    SizedBox(height: 8.v),
                    Padding(
                      padding: EdgeInsets.only(left: 23.h),
                      child: Text(
                        "lbl_plus_t_t".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.titleLargeBlack900,
                      ),
                    ),
                    SizedBox(height: 5.v),
                    // You can display older notifications or a different category if needed
                    // Add any additional ListView or static widgets as necessary
                  ],
                ),
              ),
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
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarTitle(
            text: "Notifications".tr,
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

  Widget _buildNotificationItem(
      BuildContext context, NotificationModel notification) {
    return Container(
      height: 78.v,
      width: 347.h,
      margin: EdgeInsets.only(left: 2.h),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.fromLTRB(6.h, 11.v, 6.h, 10.v),
              decoration: AppDecoration.outlineBlueGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the user's notification content
                  Container(
                    height: 39.v,
                    width: 42.h,
                    margin: EdgeInsets.only(bottom: 17.v),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant
                              .imgAvatar, // Use dynamic data as needed
                          height: 34.adaptSize,
                          width: 34.adaptSize,
                          alignment: Alignment.topLeft,
                        ),
                        Icon(
                          Icons.notifications, // Use appropriate icon
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 212.h,
                    margin: EdgeInsets.only(left: 8.h, bottom: 9.v),
                    child: Text(
                      notification.message ?? "No message",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(height: 1.40),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage34,
                    height: 30.v,
                    width: 54.h,
                    margin: EdgeInsets.only(left: 8.h, bottom: 26.v),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 65.h),
              child: Text(
                notification.timestamp != null
                    ? "${notification.timestamp!.difference(DateTime.now()).inHours} il y a des heures" // Format timestamp as needed
                    : "maintenant",
                style: theme.textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
