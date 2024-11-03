import 'listtext_item_model.dart';

class ListeprojectsModel {
  List<ListtextItemModel> listprojects;

  ListeprojectsModel({List<ListtextItemModel>? projects})
      : listprojects = projects ?? [];
}

class ListcategoriesModel {
  List<CategoryItemModel> categoryItems;

  ListcategoriesModel({List<CategoryItemModel>? categories})
      : categoryItems = categories ?? [];
}

class AcceuilClientModel {}
