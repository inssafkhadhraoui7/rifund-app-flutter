import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/acceuil_client_page/models/listtext_item_model.dart';
import 'package:rifund/screens/chat_box_screen/chat_box_screen.dart';
import 'package:rifund/screens/financer_projet_screen/financer_projet_screen.dart';
import 'package:rifund/widgets/app_bar/appbar_subtitle.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    // Construct the slider items based on project images
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
                _buildSlider(context, sliderItems),
                SizedBox(height: 10.v),
                _buildProjectDetails(context),
                SizedBox(height: 5.v),
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
                  onPressed: () => _showJoinCommunityDialog(context),
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
              // SizedBox(height: 10.v),
              // Padding(
              //   padding: EdgeInsets.only(left: 2.h),
              //   child: Text("\$${widget.project.budget.toString()}",
              //       style: CustomTextStyles.titleLargeInterOnPrimary),
              // ),
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
                    widget.project.description ?? "Pas de description",
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(height: 1.40),
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

  void _showJoinCommunityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Vous-etes sure pour rejoindre cette communauté?'),
          actions: <Widget>[
            TextButton(
              child: Text('Rejoindre Communauté'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBoxScreen()),
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
  }
}
