import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notifications = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                String senderName = notification['senderName'];
                String senderImage = notification['senderImage'];
                String message = notification['message'];
                String time = 'Just now'; // You can format the timestamp if needed

                return _buildNotificationCard(
                    senderName, senderImage, message, time);
              },
            );
          },
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: AppbarTitle(
        text: "Notifications".tr,
        margin: EdgeInsets.only(
          left: 80.h,
          top: 2.v,
          right: 79.h,
        ),
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildNotificationCard(String senderName, String senderImage,
      String message, String time) {
    return Container(
      height: 78.v,
      width: 347.h,
      margin: EdgeInsets.only(left: 2.h, right: 2.h, top: 8.v),
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
                  Container(
                    height: 39.v,
                    width: 42.h,
                    margin: EdgeInsets.only(bottom: 17.v),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImageView(
                          imagePath: senderImage,
                          height: 34.adaptSize,
                          width: 34.adaptSize,
                          alignment: Alignment.topLeft,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: const Icon(
                            Icons.comment,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 212.h,
                    margin: EdgeInsets.only(
                      left: 8.h,
                      bottom: 9.v,
                    ),
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(
                        height: 1.40,
                      ),
                    ),
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
                time,
                style: theme.textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
