import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../liste_de_communaut_page/provider/liste_de_communaut_provider.dart';
import 'widgets/communitycardsection_item_widget.dart';
import 'widgets/joinCommunities.dart';

class ListeDeCommunautPage extends StatefulWidget {
  @override
  _ListeDeCommunautPageState createState() => _ListeDeCommunautPageState();

  static builder(BuildContext context) {}
}

class _ListeDeCommunautPageState extends State<ListeDeCommunautPage> {
  bool _showCommunitySection = false; // For "Mes Communautés"
  bool _showJoinCommunitySection = false; // For "Autres"
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ListeDeCommunautProvider>(context, listen: false);
      provider.fetchAllCommunities(); // Call to fetch communities
      provider.fetchAllJoinCommunities();
    });
  }

  void _toggleCommunitySection() {
    setState(() {
      _showCommunitySection = true;
      _showJoinCommunitySection = false; // Hide "Autres" when "Mes Communautés" is clicked
    });
  }

  void _toggleJoinCommunitySection() {
    setState(() {
      _showCommunitySection = false; // Hide "Mes Communautés" when "Autres" is clicked
      _showJoinCommunitySection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.orange50,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => NavigatorService.goBack(),
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

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillOrange,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.h),
              child: Column(
                children: [
                  SizedBox(height: 20.v),
                  _buildRowListedeOneSection(context),
                  SizedBox(height: 30.v),
                  if (_showCommunitySection) // Show "Mes Communautés" section conditionally
                    SizedBox(
                      height: 300, // Adjust the height as needed
                      child: _buildCommunityCardSection(context),
                    ),
                  if (_showJoinCommunitySection) // Show "Autres" section conditionally
                    SizedBox(
                      height: 300, // Adjust the height as needed
                      child: _buildJoinCommunityCardSection(context),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowListedeOneSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 3),
        Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _toggleCommunitySection, // Show "Mes Communautés"
                    style: ElevatedButton.styleFrom(),
                    child: Text(
                      "Mes Communautés",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _toggleJoinCommunitySection, // Show "Autres"
                    style: ElevatedButton.styleFrom(),
                    child: Text(
                      "Autres",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Refactored method to display community cards
Widget _buildCommunityCardSection(BuildContext context) {
  final String idUser = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user ID

  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.h),
      child: Consumer<ListeDeCommunautProvider>(
        builder: (context, provider, child) {
          // Handle loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (provider.errorMessage.isNotEmpty) {
            return _buildErrorState(provider.errorMessage);
          }

          // Handle empty state
          if (provider.communities.isEmpty) {
            return _buildEmptyState("Pas de communautés");
          }

          // Display list of communities
          return ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(height: 18.h),
            itemCount: provider.communities.length,
            itemBuilder: (context, index) {
              final community = provider.communities[index];
              final communityId = community.communityId;
              final projectId = community.projectId ?? ''; // Retrieve projectId if available in model

              return CommunitycardsectionItemWidget(
                model: community,
                communityId: communityId,
                projectId: projectId, // Pass the project ID
                userId: idUser,       // Pass the user ID
              );
            },
          );
        },
      ),
    ),
  );
}

// Refactored method to display joined community cards
Widget _buildJoinCommunityCardSection(BuildContext context) {
  final String idUser = FirebaseAuth.instance.currentUser?.uid ?? '';

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 3.h),
    child: Consumer<ListeDeCommunautProvider>(
      builder: (context, provider, child) {
        // Handle loading state
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (provider.errorMessage.isNotEmpty) {
          return _buildErrorState(provider.errorMessage);
        }

        // Handle empty state for joined communities
        if (provider.joinedCommunities.isEmpty) {
          return _buildEmptyState("Pas de communautés jointes");
        }

        // Display list of joined communities
        return ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => SizedBox(height: 18.h),
          itemCount: provider.joinedCommunities.length,
          itemBuilder: (context, index) {
            final community = provider.joinedCommunities[index];
            return JoinCommunityCardItemWidget(
              model: community,
              communityId: community.communityId,
              userId: idUser,
            );
          },
        );
      },
    ),
  );
}

// Reusable method to handle error states
Widget _buildErrorState(String errorMessage) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        errorMessage,
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    ),
  );
}

// Reusable method to handle empty states
Widget _buildEmptyState(String message) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    ),
  );
}

}


