import '../../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class UserprofileItemModel {
  UserprofileItemModel({
    this.seventy,
    this.circleimage,
    this.titreduprojet,
    this.id,
  }) {
    seventy = seventy ?? "0 %"; // Default to 0%
    circleimage = circleimage ?? ImageConstant.imgprofile;
    titreduprojet = titreduprojet ?? "Titre du projet";
    id = id ?? "";
  }

  String? seventy;     // Financing percentage
  String? circleimage; // First image
  String? titreduprojet; // Project title
  String? id;         // Project ID
}
