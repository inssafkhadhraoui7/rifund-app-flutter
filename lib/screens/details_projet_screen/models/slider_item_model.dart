/// This class is used in the [slider_item_widget] screen.

// ignore_for_file: must_be_immutable

class SliderItemModel {
  SliderItemModel({this.id, this.title}) {
    id = id ?? "";
    title = title ?? "";
  }

  String? id;
  String? title;
}
