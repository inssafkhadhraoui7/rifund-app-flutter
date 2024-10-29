import '../../../core/app_export.dart';
import 'listtext_item_model.dart';

class ListeprojectsModel {
  List<ListtextItemModel> listprojects = [];

  ListeprojectsModel({List<ListtextItemModel>? projects})
      : listprojects = projects ?? [];
}

class AcceuilClientModel {
  List<CategoryItemModel> listcategoryItemList;

  AcceuilClientModel()
      : listcategoryItemList = [
          CategoryItemModel(images: ImageConstant.imgImage28, title: "Enérgie"),
          CategoryItemModel(
              images: ImageConstant.imgImage37, title: "Immobilier"),
          CategoryItemModel(images: ImageConstant.imgImage38, title: "Santé"),
          CategoryItemModel(
              images: ImageConstant.imgImage3965x50, title: "Education"),
        ];
}
