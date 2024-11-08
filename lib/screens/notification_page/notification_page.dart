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
        body: SingleChildScrollView(
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      2, // Number of times _buildStackTaoufikKes should be repeated
                  itemBuilder: (context, index) {
                    return _buildColumnPropertyOne(context);
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      7, // Number of times _buildStackTaoufikKes should be repeated
                  itemBuilder: (context, index) {
                    return _buildStackTaoufikKes(context);
                  },
                ),
              ],
            ),
          ),
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

  /// Section Widget
  Widget _buildColumnPropertyOne(BuildContext context) {
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
                  Container(
                    height: 39.v,
                    width: 42.h,
                    margin: EdgeInsets.only(bottom: 17.v),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgprofile,
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
                      "Imen Missaoui a envoyé un message sur  communauté Projet energie. ".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(
                        height: 1.40,
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage34,
                    height: 30.v,
                    width: 54.h,
                    margin: EdgeInsets.only(
                      left: 8.h,
                      bottom: 26.v,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 65.h),
              child: Text(
                "lbl_il_y_a_2_heures".tr,
                style: theme.textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildStackTaoufikKes(BuildContext context) {
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
                  Container(
                    height: 39.v,
                    width: 42.h,
                    margin: EdgeInsets.only(bottom: 17.v),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgAvatar,
                          height: 34.adaptSize,
                          width: 34.adaptSize,
                          alignment: Alignment.topLeft,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
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
                      "Taoufik keskes a fait un don sur projet énérgétique".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(
                        height: 1.40,
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage34,
                    height: 30.v,
                    width: 54.h,
                    margin: EdgeInsets.only(
                      left: 8.h,
                      bottom: 26.v,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 65.h),
              child: Text(
                "lbl_il_y_a_2_jours".tr,
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
