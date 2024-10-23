import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/cr_er_communaut_screen/cr_er_communaut_screen.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/communitycardsection_item_model.dart';
import 'provider/liste_de_communaut_provider.dart';
import 'widgets/communitycardsection_item_widget.dart'; // ignore_for_file: must_be_immutable

class ListeDeCommunautPage extends StatefulWidget {
  const ListeDeCommunautPage({Key? key}) : super(key: key);

  @override
  ListeDeCommunautPageState createState() => ListeDeCommunautPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListeDeCommunautProvider(),
      child: const ListeDeCommunautPage(),
    );
  }
}

class ListeDeCommunautPageState extends State<ListeDeCommunautPage> {
  @override
  void initState() {
    super.initState();
    // You may want to fetch community data here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.orange50,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOrange,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 26.h),
                  child: Column(
                    children: [
                      SizedBox(height: 48.v),
                      _buildRowListedeOneSection(context),
                      SizedBox(height: 17.v),
                      _buildCommunityCardSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => onTapImage(context),
          ),
          AppbarTitle(
            text: "Liste des Communautés".tr,
            margin: EdgeInsets.only(left: 50.h, top: 2.v, right: 40.h),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildRowListedeOneSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Text(
            "Liste des Communautés".tr,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.black),
          iconSize: 30,
          alignment: Alignment.center,
          onPressed: () {
            // Ensure you have the correct projectId to pass
            final projectId = 'your_project_id'; // Replace with actual project ID logic
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrErCommunautScreen(projectId: projectId)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommunityCardSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Consumer<ListeDeCommunautProvider>(
          builder: (context, provider, child) {
            final communityList = provider.listeDeCommunautModelObj.communitycardsectionItemList;
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 22.v),
              itemCount: communityList.length,
              itemBuilder: (context, index) {
                CommunitycardsectionItemModel model = communityList[index];
                return CommunitycardsectionItemWidget(model);
              },
            );
          },
        ),
      ),
    );
  }

  void onTapImage(BuildContext context) {
    NavigatorService.goBack();
  }
}
