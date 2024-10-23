import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart'; // Importing provider package
import 'package:rifund/screens/liste_de_communaut_page/models/communitycardsection_item_model.dart';
=======
import 'package:provider/provider.dart';
import 'package:rifund/screens/cr_er_communaut_screen/cr_er_communaut_screen.dart';
>>>>>>> ahmed
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../liste_de_communaut_page/provider/liste_de_communaut_provider.dart';
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
<<<<<<< HEAD
    Provider.of<ListeDeCommunautProvider>(context, listen: false).fetchCommunities();
=======
    // You may want to fetch community data here if necessary
>>>>>>> ahmed
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
<<<<<<< HEAD
                child: SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.h),
                    child: Column(
                      children: [
                        SizedBox(height: 48.v),
                        _buildRowListedeOneSection(context),
                        SizedBox(height: 17.v),
                        _buildCommunityCardSection(context),
                      ],
                    ),
=======
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 26.h),
                  child: Column(
                    children: [
                      SizedBox(height: 48.v),
                      _buildRowListedeOneSection(context),
                      SizedBox(height: 17.v),
                      _buildCommunityCardSection(context),
                    ],
>>>>>>> ahmed
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
<<<<<<< HEAD
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapImage(context);
            },
=======
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => onTapImage(context),
>>>>>>> ahmed
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
<<<<<<< HEAD
      mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h), // Add horizontal margin
=======
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
>>>>>>> ahmed
          child: Text(
            "Liste des Communautés".tr,
            style: theme.textTheme.headlineSmall,
          ),
        ),
<<<<<<< HEAD
=======
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
>>>>>>> ahmed
      ],
    );
  }

  Widget _buildCommunityCardSection(BuildContext context) {
    return Expanded(
      child: Padding(
<<<<<<< HEAD
        padding: EdgeInsets.only(left: 3.h, right: 5.h),
        child: Consumer<ListeDeCommunautProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }
           return ListView.builder(
         itemCount: provider.communities.length,
         itemBuilder: (context, index) {
          final community = provider.communities[index] as CommunitycardsectionItemModel;
          return ListTile(
          leading: Image.network(
        community.imageUrl,  // Load image from Firebase Storage
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(community.name),
      subtitle: Text(community.description),
    );
  },
);

=======
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
>>>>>>> ahmed
          },
        ),
      ),
    );
  }

  void onTapImage(BuildContext context) {
    NavigatorService.goBack();
  }
}
